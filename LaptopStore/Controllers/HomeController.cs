using LaptopStore.Data;
using LaptopStore.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace LaptopStore.Controllers
{
    public class HomeController : Controller
    {
  
        private readonly AppDbContext _context;

        public HomeController(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var TopProducts = await _context.Products
                .Where(p => p.StockQuantity >= 0)
                .Include(p => p.Category)
                .Include(p => p.Supplier)
                .OrderByDescending(p => p.Rating)
                .Take(4)
                .ToListAsync();
      
            var AllProducts = await _context.Products.ToListAsync();

            var AllCustomers = await _context.Customers.ToListAsync();

            var AllSuppliers = await _context.Suppliers.ToListAsync();

            ViewBag.ProductCount = AllProducts.Count;
            ViewBag.CustomerCount = AllCustomers.Count;
            ViewBag.SupplierCount = AllSuppliers.Count;

            return View(TopProducts);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult About()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
