using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LaptopStore.Data;
using LaptopStore.Models;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using System.Collections.Generic;

namespace LaptopStore.Controllers
{
    public class ProductsController : Controller
    {
        private readonly AppDbContext _context;

        public ProductsController(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Details(int id)
        {
            var product = await _context.Products.FindAsync(id);

            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }


        public async Task<IActionResult> Index(
            string searchString,
            string categoryFilter,
            string brandFilter,
            decimal? minPrice,
            decimal? maxPrice,
            int? minRating,
            string sortOrder)
        {
            // Get categories with product counts
            var categories = await _context.Categories
                .Select(c => new {
                    Category = c,
                    ProductCount = _context.Products.Count(p => p.CategoryId == c.CategoryId)
                })
                .ToListAsync();

            ViewBag.CategoriesWithCounts = categories;
            ViewBag.Suppliers = await _context.Products.Select(p => p.Supplier.Name).Distinct().ToListAsync();
            ViewBag.CurrentSearch = searchString;
            ViewBag.CurrentCategory = categoryFilter;
            ViewBag.CurrentBrand = brandFilter;
            ViewBag.CurrentMinPrice = minPrice;
            ViewBag.CurrentMaxPrice = maxPrice;
            ViewBag.CurrentMinRating = minRating;
            ViewBag.CurrentSort = sortOrder;

            // Product query
            var query = _context.Products
                .Include(p => p.Category)
                .Include(p => p.Supplier)
                .AsQueryable();

            // Apply filters
            if (!string.IsNullOrEmpty(searchString))
            {
                query = query.Where(p => p.Name.Contains(searchString) ||
                                       p.Description.Contains(searchString));
            }

            if (!string.IsNullOrEmpty(categoryFilter))
            {
                query = query.Where(p => p.Category.Name == categoryFilter);
            }

            if (!string.IsNullOrEmpty(brandFilter))
            {
                query = query.Where(p => p.Supplier.Name == brandFilter);
            }

            if (minPrice.HasValue)
            {
                query = query.Where(p => p.Price >= minPrice);
            }

            if (maxPrice.HasValue)
            {
                query = query.Where(p => p.Price <= maxPrice);
            }

            if (minRating.HasValue)
            {
                query = query.Where(p => p.Rating >= minRating);
            }

            // Apply sorting
            switch (sortOrder)
            {
                case "price_asc":
                    query = query.OrderBy(p => p.Price);
                    break;
                case "price_desc":
                    query = query.OrderByDescending(p => p.Price);
                    break;
                case "rating_desc":
                    query = query.OrderByDescending(p => p.Rating);
                    break;
                case "newest":
                default:
                    query = query.OrderByDescending(p => p.CreatedAt);
                    break;
            }

            var products = await query.ToListAsync();
            return View(products);
        }

        
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Product/AddToCart")]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> AddToCart(int productId)
        {
            var product = await _context.Products.FindAsync(productId);

            if (product == null)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                // Your cart logic here

                return Json(new { success = true, message = "Done adding product id ( " + productId.ToString() + " ) in cart" });
            }

            // Repopulate the product details before returning the view
            product = await _context.Products
                .Include(p => p.Category)
                .Include(p => p.Supplier)
                .FirstOrDefaultAsync(p => p.ProductId == productId);

            return View("Details", product);
        }
    }
}