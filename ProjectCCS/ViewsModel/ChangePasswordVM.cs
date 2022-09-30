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
        [Display(Name ="Password")]
        public string Password { get; set; }

        [StringLength(50)]
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "New Password")]
        public string NewPassword { get; set; }

        [StringLength(50)]
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Re-Password")]
        [Compare(nameof(NewPassword),ErrorMessage ="Password doesn't match")]
        public string Repassword { get; set; }
    }
}