using System;
using System.ComponentModel.DataAnnotations;

namespace LaptopStore.Models
{
    public class DashboardViewModel
    {
        public decimal TotalSales { get; set; }
        public int TotalProducts { get; set; }
        public int TotalCustomers { get; set; }
        public int NewProducts { get; set; }
        public int NewCustomers { get; set; }
        public int NewOrders { get; set; }
        public List<Order> RecentOrders { get; set; }
    }
}
