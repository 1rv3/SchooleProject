using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LaptopStore.Models;
using LaptopStore.Data;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Linq;
using System.Threading.Tasks;

namespace LaptopStore.Controllers
{
    public class AdminController : Controller
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }
        public IActionResult Dashboard()
        {
            var model = new DashboardViewModel
            {
                TotalSales = _context.Orders.Sum(o => o.TotalAmount),
                TotalProducts = _context.Products.Count(),
                TotalCustomers = _context.Customers.Count(),
                NewOrders = _context.Orders.Count(o => o.OrderDate >= DateTime.Now.AddDays(-7)),
                RecentOrders = _context.Orders
                    .Include(o => o.Customer)
                    .OrderByDescending(o => o.OrderDate)
                    .Take(5)
                    .ToList()
            };

            return View(model);
        }

        public async Task<IActionResult> Products()
        {
            var products = await _context.Products
                .Include(p => p.Category)
                .ToListAsync();
            return View("~/Views/Admin/Products/Index.cshtml", products);
        }

        public async Task<IActionResult> Customers()
        {
            var Customers = await _context.Customers.ToListAsync();
            return View("~/Views/Admin/Customers/Index.cshtml", Customers);
        }
    }
}