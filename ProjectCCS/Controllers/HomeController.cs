using ProjectCCS.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ProjectCCS.ViewsModel;
using ProjectCCS.Model;
using System.ComponentModel.DataAnnotations;
using System.Net.Mail;
using System.Globalization;
using System.Text;
using System.Security.Cryptography;
using PagedList;
using System.Web.UI;
using System.Web.UI.MobileControls;
using ProjectCCS.Momo;
using Newtonsoft.Json.Linq;
using System.Web.UI.WebControls;
using System.Net;
using System.Web.Helpers;
using System.Configuration;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;
using System.Threading.Tasks;
using GoogleAuthentication.Services;

namespace ProjectCCS.Controllers
{
    public class HomeController : Controller
    {
        ContextDB context = new ContextDB();

        public bool CheckLogin()
        {
            HttpCookie cookie = Request.Cookies["user"];
            if (cookie == null)
                return false;
            else
                return true;
        }
        public string getUser()
        {
                return Request.Cookies["user"].Value;
        }
        [HttpPost]
        public void SavefileToServer(HttpPostedFileBase file)
        {
            if (file != null && file.ContentLength > 0)
            {
                var filename = Path.GetFileName(file.FileName);
                var path = Path.Combine(Server.MapPath("~/app/img/sanpham"), filename);
                file.SaveAs(path);
            }
        }
        public void SendMail(IEnumerable<ShoppingCart> list, int IdBill)
        {
            var user = getUser();
            MailMessage mail = new MailMessage();
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com");
            mail.From = new MailAddress("congdo2603@gmail.com");
            mail.To.Add(getUser());
            mail.Subject = "CCM Technology - Đơn hàng mới";
            mail.Body = "\nĐơn hàng của bạn đã được xác nhận và sẽ được xử lý ngay.";
            mail.Body = "\nCCM Technology cảm ơn bạn đã ủng hộ sản phẩm bên Shop.";
            mail.Body += "\nMã đơn hàng: " + IdBill.ToString();
            foreach (var item in list)
            {
                mail.Body += "\n\nSản phẩm: " + context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.name).FirstOrDefault();
                mail.Body += "\nSố lượng: " + item.Amount.ToString();
                mail.Body += "\nGiá: " + String.Format(CultureInfo.CurrentCulture, "{0:C0}", ((long)item.Amount * (long)context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.price).FirstOrDefault())).ToString();
            }
            mail.Body += "\n\nTổng đơn hàng: " + String.Format(CultureInfo.CurrentCulture, "{0:C0}", context.Bills.Where(p => p.idBill.Equals(IdBill)).Select(p => p.Total).FirstOrDefault()).ToString();

            smtpClient.Port = 587;
            smtpClient.Credentials = new System.Net.NetworkCredential("congdo2603@gmail.com", "zupiavgwdamnpntj");
            smtpClient.EnableSsl = true;
            smtpClient.Send(mail);
        }
        private String GetMD5(string txt)
        {
            if (txt != null)
            {
                String str = "";
                Byte[] buffer = Encoding.UTF8.GetBytes(txt);
                MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
                buffer = md5.ComputeHash(buffer);
                foreach (Byte b in buffer)
                {
                    str += b.ToString("X2");
                }
                return str;
            }
            return null;
        }



        public ActionResult Index( int? page)
        {
            // 1. Tham số int? dùng để thể hiện null và kiểu int
            // page có thể có giá trị là null và kiểu int.

            // 2. Nếu page = null thì đặt lại là 1.
            if (page == null) page = 1;

            // 3. Tạo truy vấn, lưu ý phải sắp xếp theo trường nào đó, ví dụ OrderBy
            // theo LinkID mới có thể phân trang.
            var dsproduct = (from l in context.Products
                         select l).OrderBy(x => x.id);

            // 4. Tạo kích thước trang (pageSize) hay là số Link hiển thị trên 1 trang
            int pageSize = 3;

            // 4.1 Toán tử ?? trong C# mô tả nếu page khác null thì lấy giá trị page, còn
            // nếu page = null thì lấy giá trị 1 cho biến pageNumber.
            int pageNumber = (page ?? 1);

            // 5. Trả về các Link được phân trang theo kích thước và số trang.
            return View(dsproduct.ToPagedList(pageNumber, pageSize));
            //  return View();
        }
        [HttpGet]
        [ActionName("ChangePass")]
        public ActionResult ChangePass_Get()
        {
            return View();
        }
        [HttpPost]
        [ActionName("ChangePass")]
        public ActionResult ChangePass_Post(ChangePasswordVM cp)
        {
            if(!ModelState.IsValid)
            {
                return View();
            }
            var user = getUser();
            User usr = context.Users.Where(p => p.Email.Equals(user)).FirstOrDefault();
            if(!usr.Password.Equals(GetMD5(cp.Password)))
            {
                ModelState.AddModelError("error", "Password doesn't match");
                return View();
            }    
            usr.Password = GetMD5(cp.NewPassword);
            context.Entry(usr).State = System.Data.Entity.EntityState.Modified;
            context.SaveChanges();
            return RedirectToAction("Logout");
        }
        public ActionResult ShoppingCart()
        {
            if (!CheckLogin())
                return RedirectToAction("Login");

            var usr = getUser();
            ViewBag.ShoppingCart = context.ShoppingCarts.Join(
                context.Products,
                p=>p.id,
                q=>q.id,
                (p,q)=>new {p,q}
                )
                .Where(p => p.p.Email.Equals(usr))
                .Select(p => new ShoppingCartVM
                {
                    id = p.q.id,
                    name = p.q.name,
                    image = p.q.image,
                    price = p.q.price,
                    Amount = p.p.Amount,
                })
                .ToList();
            ViewBag.User = context.Users.Where(p => p.Email.Equals(usr)).FirstOrDefault();
            return View();
        }
        public ActionResult AddToCart(int id)
        {
            if (!CheckLogin())
            {
                return RedirectToAction("Login");
            }
            var email = getUser();
            ShoppingCart sc = context.ShoppingCarts.Where(p => p.Email.Equals(email) && p.id.Equals(id)).FirstOrDefault();
            if(sc==null)
            {
                sc = new ShoppingCart();
                sc.Email = email;
                sc.id = id;
                sc.Amount = 1;
                context.ShoppingCarts.Add(sc);
                context.SaveChanges();
            }
            else
            {
                sc.Amount++;
                context.Entry(sc).State = System.Data.Entity.EntityState.Modified;
                context.SaveChanges();
            }
            return RedirectToAction("ListProduct");
        }
        public ActionResult RemoveCart(int id)
        {
            var user = getUser();
            ShoppingCart spc = context.ShoppingCarts.Where(p => p.Email.Equals(user) && p.id.Equals(id)).FirstOrDefault();
            if(spc!=null)
            {
                context.ShoppingCarts.Remove(spc);
                context.SaveChanges();
            }
            return RedirectToAction("ShoppingCart");
        }
        [HttpPost]
        public ActionResult UpdateCart(FormCollection frm)
        {
            var user = getUser();
            var id = int.Parse(frm.Get("id"));
            ShoppingCart spc = context.ShoppingCarts.Where(p => p.Email.Equals(user) && p.id.Equals(id)).FirstOrDefault();
            if(spc!=null)
            {
                spc.Amount = int.Parse(frm.Get("amount"));
                context.Entry(spc).State = System.Data.Entity.EntityState.Modified;
                context.SaveChanges();
            }
            return RedirectToAction("ShoppingCart");
        }
        public ActionResult ListProduct()
        {
            List<Product> list = context.Products.ToList();
            ViewBag.categories = context.Categories.ToList();
            return View(list);
        }
        public ActionResult HistoryCart()
        {
            var user = getUser();
            ViewBag.HistoryCart = context.Bills.Where(p => p.Email.Equals(user)).ToList();
            return View();
        }
        public ActionResult DetailProduct(int id)
        {
            Product pd = context.Products.FirstOrDefault(p => p.id == id);
            return View(pd);
        }
        public ActionResult UserDashBoard()
        {
            if(!CheckLogin())
            {
                return RedirectToAction("Login");
            }
            else
            {
                var usremail = getUser();
                User usr = context.Users.Where(p => p.Email.Equals(usremail)).FirstOrDefault();
                return View(usr);
            }
        }
        [HttpPost]
        public ActionResult Update(User user)
        {
            if(!(ModelState.IsValidField("Name") && ModelState.IsValidField("Phone") && ModelState.IsValidField("Address")))
            {
                return View("UserDashBoard");
            }    
            var usermail = getUser();
            User usr = context.Users.Where(p => p.Email.Equals(usermail)).FirstOrDefault();
            usr.Name = user.Name.Trim();
            usr.Phone = user.Phone.Trim();
            usr.Address = user.Address.Trim();
            context.Entry(usr).State = System.Data.Entity.EntityState.Modified;
            context.SaveChanges();
            return RedirectToAction("UserDashBoard");
        }

        public ActionResult productManager()
        {
            List<Product> list = context.Products.ToList();
            ViewBag.lst = list;
            ViewBag.Categories = context.Categories.ToList();
            return View();

        }
        
        [HttpPost]
        public ActionResult Add(Product product, HttpPostedFileBase file)
        {
            if (!(ModelState.IsValidField("name") && ModelState.IsValidField("descriptions") && ModelState.IsValidField("price")))
            {
                List<Product> list = context.Products.ToList();
                ViewBag.lst = list;
                ViewBag.Categories = context.Categories.ToList();
                return View("productManager");
            }
            if (file != null && file.ContentLength > 0)
            {
                SavefileToServer(file);
                product.image = String.Concat("/app/img/sanpham/", Path.GetFileName(file.FileName));
            }
            else
            {
                product.image = "/app/img/product-temp.png";
            }
            context.Products.Add(product);
            context.SaveChanges();
            return RedirectToAction("productManager");
        }
        public ActionResult deleteProduct(int id)
        {
            Product pd = context.Products.FirstOrDefault(p => p.id == id);

            context.Products.Remove(pd);
            context.SaveChanges();

            return RedirectToAction("productManager");
        }
        public ActionResult editProduct(int id)
        {
            Product pd = context.Products.FirstOrDefault(p => p.id == id);
            return View(pd);
        }

        [HttpPost]
        public ActionResult Edit(Product product, HttpPostedFileBase file)
        {

            Product pd = context.Products.FirstOrDefault(p => p.id == product.id);
            if (!ModelState.IsValid)
            {
                return View("editProduct", pd);
            }
            pd.name = product.name.Trim();
            pd.price = product.price;
            pd.descriptions = product.descriptions.Trim();

            if (file != null && file.ContentLength > 0)
            {
                SavefileToServer(file);
                pd.image = String.Concat("/app/img/sanpham/", Path.GetFileName(file.FileName));
            }
            else
            {
                pd.image = product.image;
            }
            context.SaveChanges();
            return RedirectToAction("productManager");
        }


        public ActionResult Filter(int id)
        {
            ViewBag.categories = context.Categories.ToList();
            return View("ListProduct", context.Products.Where(p => p.categoryId.Equals(id)).ToList());
        }
        [HttpPost]
        public ActionResult Find(string txtKeyWord)
        {
            ViewBag.categories = context.Categories.ToList();
            var list = context.Products.Where(p => p.name.Contains(txtKeyWord)).ToList();
            return View("ListProduct", list);
        }

        [HttpGet]
        [ActionName("Login")]
        public ActionResult Login_get()
        {
            var clientId = "314107451077-3986rlpibpbvffboa0a9kqqtc837ad9a.apps.googleusercontent.com";
            var url = "https://localhost:44342/Home/Register";
            var response = GoogleAuth.GetAuthUrl(clientId, url);
            ViewBag.response = response;
            return View();
        }
        [HttpPost]
        [ActionName("Login")]
        public ActionResult Login_Post(User user)
        {
            if (!ModelState.IsValidField("Email"))
            {
                return View();
            }
            else
            {
                var passMD5 = GetMD5(user.Password);
                var login = context.Users.Where(p => p.Email.Equals(user.Email) && p.Password.Equals(passMD5)).FirstOrDefault();
                if (login != null)
                {
                    HttpCookie cookie = new HttpCookie("user", user.Email.ToString());
                    cookie.Expires.AddHours(8);
                    HttpContext.Response.SetCookie(cookie);
                    return RedirectToAction("Index");
                }
                else
                {
                    ViewBag.Message = "Tài khoản hoặc mật khẩu của bạn không đúng!";
                    return View();
                }
            }
        }

        public async Task<ActionResult> GoogleLoginCallBack(string code)
        {
            var clientId = "314107451077-3986rlpibpbvffboa0a9kqqtc837ad9a.apps.googleusercontent.com";
            var url = "https://localhost:44342/Home/Register";
            var clientsecret = "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";
            var token = await GoogleAuth.GetAuthAccessToken(code, clientId, clientsecret, url);
            var userProfile = await GoogleAuth.GetProfileResponseAsync(token.AccessToken.ToString());
            var googleUser = JsonConvert.DeserializeObject<User>(userProfile);
            return View();
        }

        [HttpGet]
        [ActionName("Register")]
        public ActionResult Register_get()
        {
            return View();
        }

        [HttpPost]
        [ActionName("Register")]
        public ActionResult Register_post(User user)
        {
            if(!ModelState.IsValid)
            {
                return View();
            }
            if (context.Users.Where(p => p.Email.Equals(user.Email)).FirstOrDefault() != null)
            {
                ModelState.AddModelError("EmailUsed", "Email này đã được sử dụng!");
                return View();
            }
            user.Password = GetMD5(user.Password);
            context.Users.Add(user);
            context.SaveChanges();
            return RedirectToAction("Login");
        }
        public ActionResult Logout()
        {
            var c = new HttpCookie("user");
            c.Expires = DateTime.Now;
            Response.Cookies.Add(c);
            return RedirectToAction("Index");
        }
        public ActionResult Checkout()
        {
            var user = getUser();
            var list = context.ShoppingCarts.Where(p => p.Email.Equals(user)).ToList();
            if(list.Count==0)
            {
                return RedirectToAction("ListProduct");
            }
            var total = 0L;
            Bill b = new Bill();
            b.Email = user;
            foreach(var item in list)
            {
                total += (long)item.Amount * (long)context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.price).FirstOrDefault();
            }
            b.Total = total;
            b.Status = false;
            b.Date = System.DateTime.Now;
            context.Bills.Add(b);
            context.SaveChanges();

            foreach(var item in list)
            {
                BillDetail bd = new BillDetail();
                bd.idBill = b.idBill;
                bd.id = item.id;
                bd.amount = item.Amount;
                context.BillDetails.Add(bd);
                context.SaveChanges();
            }

            var sc = context.ShoppingCarts.Where(p => p.Email.Equals(user)).ToList();
            foreach(var item in sc)
            {
                context.ShoppingCarts.Remove(item);
                context.SaveChanges();
            }
            SendMail(list, b.idBill);


            return RedirectToAction("PaymentTM");
        }
        public ActionResult BillManager()
        {
            var list = context.Bills.Join(
                        context.Users,
                        b => b.Email,
                        u => u.Email,
                        (b, u) => new { b, u }
                    ).Select(
                        p => new BillManagerVM
                        {
                            Address = p.u.Address,
                            Name = p.u.Name,
                            idBill = p.b.idBill,
                            Date = p.b.Date,
                            Total = p.b.Total,
                            Status = p.b.Status
                        }
                    ).ToList();
            return View(list);
        }
        public ActionResult Complete(int idBill)
        {
            var bill = context.Bills.Where(p => p.idBill.Equals(idBill)).FirstOrDefault();
            if(bill!=null)
            {
                bill.Status = true;
                context.Entry(bill).State = System.Data.Entity.EntityState.Modified;
                context.SaveChanges();
            }
            return RedirectToAction("BillManager");
        }
        public ActionResult UserManager()
        {
            var list = context.Users.ToList();
            return View(list);
        }
        public ActionResult DeleteUser(string uEmail)
        {
            User u = context.Users.Where(p => p.Email.Equals(uEmail)).FirstOrDefault();
            if(u!=null)
            {
                context.Users.Remove(u);
                context.SaveChanges();
            }
            return RedirectToAction("UserManager");
        }
        public ActionResult UserFilter(string txtSearch)
        {
            var list = context.Users.Where(p => p.Address.Contains(txtSearch) || p.Email.Contains(txtSearch) || p.Name.Contains(txtSearch) || p.Phone.Contains(txtSearch)).ToList();
            return View("UserManager", list);
        }

        public ActionResult Payment()
        {
            var user = getUser();
            var list = context.ShoppingCarts.Where(p => p.Email.Equals(user)).ToList();
            if (list.Count == 0) 
            {
                return RedirectToAction("ListProduct");
            }
            var total = 0L;
            //request params need to request to MoMo system

            string endpoint = "https://test-payment.momo.vn/gw_payment/transactionProcessor";
            string partnerCode = "MOMOKO6R20220526";
            string accessKey = "UwBfinvR6t8nPn5H";
            string serectkey = "2NcLVlpBPVt1m0cqanWFqDmUEha6XCgC";
            string orderInfo = "Thanh toán dịch vụ CCM Technology";
            string returnUrl = "https://localhost:44342/Home/PaymentSuccess";
            string notifyurl = "http://ba1adf48beba.ngrok.io/Home/PaymentFail"; //lưu ý: notifyurl không được sử dụng localhost, có thể sử dụng ngrok để public localhost trong quá trình test

            Bill bill = new Bill();
            bill.Email = user;
            foreach (var item in list)
            {
                total += (long)item.Amount * (long)context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.price).FirstOrDefault();
            }
            bill.Total = total;
            bill.Status = false;
            bill.Date = System.DateTime.Now;
            context.Bills.Add(bill);
            context.SaveChanges();

            foreach (var item in list)
            {
                BillDetail bd = new BillDetail();
                bd.idBill = bill.idBill;
                bd.id = item.id;
                bd.amount = item.Amount;
                context.BillDetails.Add(bd);
                context.SaveChanges();
            }

            var sc = context.ShoppingCarts.Where(p => p.Email.Equals(user)).ToList();
            foreach (var item in sc)
            {
                context.ShoppingCarts.Remove(item);
                context.SaveChanges();
            }

            string amount = bill.Total.ToString();
            string orderid = DateTime.Now.Ticks.ToString();
            string requestId = DateTime.Now.Ticks.ToString();
            string extraData = "";

            //Before sign HMAC SHA256 signature
            string rawHash = "partnerCode=" +
                partnerCode + "&accessKey=" +
                accessKey + "&requestId=" +
                requestId + "&amount=" +
                amount + "&orderId=" +
                orderid + "&orderInfo=" +
                orderInfo + "&returnUrl=" +
                returnUrl + "&notifyUrl=" +
                notifyurl + "&extraData=" +
                extraData;

            MoMoSecurity crypto = new MoMoSecurity();
            //sign signature SHA256
            string signature = crypto.signSHA256(rawHash, serectkey);

            //build body json request
            JObject message = new JObject
            {
                { "partnerCode", partnerCode },
                { "accessKey", accessKey },
                { "requestId", requestId },
                { "amount", amount },
                { "orderId", orderid },
                { "orderInfo", orderInfo },
                { "returnUrl", returnUrl },
                { "notifyUrl", notifyurl },
                { "extraData", extraData },
                { "requestType", "captureMoMoWallet" },
                { "signature", signature }

            };

            string responseFromMomo = PaymentRequest.sendPaymentRequest(endpoint, message.ToString());
            JObject jmessage = JObject.Parse(responseFromMomo);
            SendMail(list, bill.idBill);

            return Redirect(jmessage.GetValue("payUrl").ToString());
        }

        public ActionResult BuildPC()
        {
            
            return View();
        }
        public ActionResult RegisterGG()
        {

            return View();
        }

        public ActionResult PaymentSuccess()
        {

            return View();
        }

        public ActionResult PaymentFail()
        {

            return View();
        }

        public ActionResult NewFeeds()
        {

            return View();
        }

        public ActionResult ExportToExcel()
        {
            var gv = new GridView();
            gv.DataSource = context.BillDetails
                .Where(p => p.idBill != null)
                .Select(r => new {
                    idBill = r.idBill,
                    Name = r.Bill.User.Name,
                    Email = r.Bill.Email,
                    Total = r.Bill.Total,
                    Date = r.Bill.Date,
                })
                .OrderBy(p => p.idBill)
                .ToList();
            gv.DataBind();
            Response.Clear();
            Response.Buffer = true;
            //Response.AddHeader("content-disposition",
            // "attachment;filename=GridViewExport.xls");
            Response.Charset = "utf-8";
            Response.ContentType = "application/ms-excel";
            Response.AddHeader("content-disposition", "attachment; filename=QL HOADON.xls");
            //Mã hóa chữa sang UTF8
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.BinaryWrite(System.Text.Encoding.UTF8.GetPreamble());

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            for (int i = 0; i < gv.Rows.Count; i++)
            {
                //Apply text style to each Row
                gv.Rows[i].Attributes.Add("class", "textmode");
            }
            //Add màu nền cho header của file excel
            gv.HeaderRow.BackColor = System.Drawing.Color.DarkBlue;
            //Màu chữ cho header của file excel
            gv.HeaderStyle.ForeColor = System.Drawing.Color.White;
            gv.HeaderRow.Cells[0].Text = "Số Hóa Đơn";
            gv.HeaderRow.Cells[1].Text = "Tên Khách Hàng";
            gv.HeaderRow.Cells[2].Text = "Email";
            gv.HeaderRow.Cells[3].Text = "Tổng Tiền";
            gv.HeaderRow.Cells[4].Text = "Thời gian mua";

            gv.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
            var model = context.BillDetails
                .OrderBy(p => p.idBill)
                .ToList();
            return View("View", model);
        }


        public ActionResult XacNhanEmail()
        {
            return View();
        }


        [HttpGet]
        public ActionResult ForgotPassword()
        {
            return View();
        }
        [HttpPost]
        public ActionResult ForgotPassword(string Email)
        {
            string message = "";
            bool status = false;

            using (ContextDB dc = new ContextDB())
            {
                var account = dc.Users.Where(a => a.Email == Email).FirstOrDefault();
                if (account != null)
                {
                    //gui mail de reset lai password
                    string resetCode = Guid.NewGuid().ToString();
                    SendVerificationLinkEmail(account.Email, resetCode, "ResetPassword");
                    account.ResetPasswordCode = resetCode;
                    dc.Configuration.ValidateOnSaveEnabled = false;
                    dc.SaveChanges();
                    message = "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn.";
                    return RedirectToAction("XacNhanEmail", "Home");
                }
                else
                {
                    message = "Không tìm thấy tài khoản";
                }
            }
            ViewBag.Message = message;
            return View();
        }

        public ActionResult ResetPassword(string id)
        {

            if (string.IsNullOrWhiteSpace(id))
            {
                return HttpNotFound();
            }

            using (ContextDB dc = new ContextDB())
            {
                var user = dc.Users.Where(a => a.ResetPasswordCode == id).FirstOrDefault();
                if (user != null)
                {
                    ResetPasswordModel model = new ResetPasswordModel();
                    model.ResetCode = id;
                    return View(model);
                }
                else
                {
                    return HttpNotFound();
                }
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ResetPassword(ResetPasswordModel model)
        {
            var message = "";
            if (ModelState.IsValid)
            {
                using (ContextDB dc = new ContextDB())
                {
                    var user = dc.Users.Where(a => a.ResetPasswordCode == model.ResetCode).FirstOrDefault();
                    if (user != null)
                    {
                        
                        user.Password = GetMD5(model.NewPassword);
                        user.ResetPasswordCode = "";
                        dc.Configuration.ValidateOnSaveEnabled = false;
                        dc.SaveChanges();
                        message = "Đã cập nhật mật khẩu";
                        return RedirectToAction("Login", "Home");
                    }
                }
            }
            else
            {
                message = "Có lỗi xảy ra";
            }
            ViewBag.Message = message;
            return View(model);
        }

        [NonAction]
        private bool IsEmailExist(string email)
        {
            using (ContextDB dc = new ContextDB())
            {
                var v = dc.Users.Where(a => a.Email == email).FirstOrDefault();
                return v != null;
            }
        }
        public void SendVerificationLinkEmail(string email, string activationCode, string emailFor = "ResetPassword")
        {
            var verifyUrl = "/Home/" + emailFor + "/" + activationCode;
            var link = Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, verifyUrl);

            var fromEmail = new MailAddress("congdo2603@gmail.com", "Cửa hàng linh kiện điện tử");
            var toEmail = new MailAddress(email);
            var fromEmailPassword = "zupiavgwdamnpntj";
            string subject = "";
            string body = "";
            if (emailFor == "ResetPassword")
            {
                subject = "Reset Password";
                body = "Xin chào.Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu tài khoản của bạn. Vui lòng nhấp vào liên kết dưới đây để đặt lại mật khẩu" +
                    "<br/><br/><a href=" + link + ">Khôi Phục Mật Khẩu</a>";
            }


            var smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromEmail.Address, fromEmailPassword)
            };

            using (var message = new MailMessage(fromEmail, toEmail)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            })
                smtp.Send(message);
        }

        [HttpPost]
        public ActionResult ImportSP(HttpPostedFileBase postedFile)
        {
            try
            {
                string filePath = string.Empty;
                if (postedFile != null)
                {
                    string path = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }

                    filePath = path + Path.GetFileName(postedFile.FileName);
                    string extension = Path.GetExtension(postedFile.FileName);
                    postedFile.SaveAs(filePath);

                    string conString = string.Empty;
                    switch (extension)
                    {
                        case ".xls":
                            conString = ConfigurationManager.ConnectionStrings["Excel03ConString"].ConnectionString;
                            break;
                        case ".xlsx":
                            conString = ConfigurationManager.ConnectionStrings["Excel07ConString"].ConnectionString;
                            break;
                    }

                    DataTable dtExcel = new DataTable();
                    conString = string.Format(conString, filePath);
                    using (OleDbConnection connExcel = new OleDbConnection(conString))
                    {
                        using (OleDbCommand cmdExcel = new OleDbCommand())
                        {
                            using (OleDbDataAdapter odaExcel = new OleDbDataAdapter())
                            {
                                cmdExcel.Connection = connExcel;
                                connExcel.Open();
                                DataTable dtExcelSchema;
                                dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                                string sheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                                connExcel.Close();

                                connExcel.Open();
                                cmdExcel.CommandText = "SELECT *from [" + sheetName + "]";
                                odaExcel.SelectCommand = cmdExcel;
                                odaExcel.Fill(dtExcel);
                                connExcel.Close();
                            }
                        }
                    }
                    conString = ConfigurationManager.ConnectionStrings["ContextDB"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(conString))
                    {
                        using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(con))
                        {
                            sqlBulkCopy.DestinationTableName = "dbo.Product";

                            sqlBulkCopy.ColumnMappings.Add("id", "id");
                            sqlBulkCopy.ColumnMappings.Add("name", "name");
                            sqlBulkCopy.ColumnMappings.Add("image", "image");
                            sqlBulkCopy.ColumnMappings.Add("descriptions", "descriptions");
                            sqlBulkCopy.ColumnMappings.Add("categoryId", "categoryId");
                            sqlBulkCopy.ColumnMappings.Add("price", "price");

                            con.Open();
                            sqlBulkCopy.WriteToServer(dtExcel);
                            con.Close();
                        }
                    }

                }
                return RedirectToAction("productManager");
            }
            catch
            {
                return RedirectToAction("productManager");
            }
        }

        public ActionResult ImportExcel()
        {
            return View();
        }

        public ActionResult PaymentTM()
        {
            return View();
        }

        public ActionResult FormSubmit()
        {
            //Validate Google recaptcha below

            var response = Request["g-recaptcha-response"];
            string secretKey = "6LdJdVwjAAAAAERrtz5FKJYPiRXkt8Db4PRrHVsq";
            var client = new WebClient();

            ViewData["Message"] = "Google reCaptcha validation success";


            //Here I am returning to Index view:

            return View("Index");
        }
    }
}