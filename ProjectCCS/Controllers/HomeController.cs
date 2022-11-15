﻿using ProjectCCS.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ProjectCCS.ViewsModel;
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
            mail.Subject = "Confirm you order";
            mail.Body = "\nThis is automatic email, please don't reply it !";
            mail.Body += "\nYour order ID: " + IdBill.ToString();
            foreach (var item in list)
            {
                mail.Body += "\n\nProduct: " + context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.name).FirstOrDefault();
                mail.Body += "\nAmount: " + item.Amount.ToString();
                mail.Body += "\nPrice: " + String.Format(CultureInfo.CurrentCulture, "{0:C0}", ((long)item.Amount * (long)context.Products.Where(p => p.id.Equals(item.id)).Select(p => p.price).FirstOrDefault())).ToString();
            }
            mail.Body += "\n\nTotal: " + String.Format(CultureInfo.CurrentCulture, "{0:C0}", context.Bills.Where(p => p.idBill.Equals(IdBill)).Select(p => p.Total).FirstOrDefault()).ToString();

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


            return RedirectToAction("HistoryCart");
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
            SendMail(list, bill.idBill);

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

            return Redirect(jmessage.GetValue("payUrl").ToString());
        }

        public ActionResult BuildPC()
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
    }
}