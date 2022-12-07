using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProjectCCS.ViewsModel
{
    public class ChangePasswordVM
    {
        [StringLength(50)]
        [Required]
        [DataType(DataType.Password)]
        [Display(Name ="Mật khẩu cũ")]
        public string Password { get; set; }

        [StringLength(50)]
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Mật khẩu mới")]
        public string NewPassword { get; set; }

        [StringLength(50)]
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Nhập lại mật khẩu mới")]
        [Compare(nameof(NewPassword),ErrorMessage ="Mjat khẩu không khớp")]
        public string Repassword { get; set; }
    }
}