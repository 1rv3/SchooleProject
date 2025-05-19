using System;
using System.ComponentModel.DataAnnotations;

namespace LaptopStore.Models
{
    public class Customer
    {
        public int CustomerId { get; set; }

        [Required]
        [StringLength(50)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(50)]
        public string LastName { get; set; }

        public string FullName => $"{FirstName} {LastName}";

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public string Phone { get; set; }
        public string Address { get; set; }
        public DateTime RegistrationDate { get; set; } = DateTime.Now;
        public ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}