using Microsoft.AspNetCore.Mvc;
using LaptopStore.Models;
using LaptopStore.Data;
using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace LaptopStore.Controllers
{
    public class AccountController : Controller
    {
        private readonly AppDbContext _context;

        public AccountController(AppDbContext context)
        {
            _context = context;
        }

        // عرض معلومات الحساب
        public IActionResult Index()
        {
            var CustomerId = 4;

            var customer = _context.Customers.FirstOrDefault(c => c.CustomerId == CustomerId);

            if (customer == null)
            {
                return NotFound();
            }

            return View(customer);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult UpdateAccount(Customer updatedCustomer)
        {
            if (!ModelState.IsValid)
            {
                return View("Index", updatedCustomer);
            }

            var existingCustomer = _context.Customers.FirstOrDefault(c => c.CustomerId == updatedCustomer.CustomerId);

            if (existingCustomer == null)
            {
                return NotFound();
            }

            existingCustomer.FirstName = updatedCustomer.FirstName;
            existingCustomer.LastName = updatedCustomer.LastName;
            existingCustomer.Email = updatedCustomer.Email;
            existingCustomer.Address = updatedCustomer.Address;
            existingCustomer.Phone = updatedCustomer.Phone;

            _context.SaveChanges();

            TempData["SuccessMessage"] = "تم تحديث الحساب بنجاح.";
            return RedirectToAction("Index", new { id = updatedCustomer.CustomerId });
        }

        public IActionResult Login()
        {
            return View();
        }
        public IActionResult Register()
        {
            return View();
        }

        public IActionResult Cart()
        {
            var CustomerProducts = _context.Orders
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .Where(o => o.CustomerId == 4)
                .SelectMany(o => o.OrderDetails)
                .Select(od => od.Product)
                .Distinct()
                .ToList();

            var Cart = new CartViewModel { Products = CustomerProducts };

            // طباعة في سيرفر الكونسول
            Console.WriteLine("====== منتجات العميل ======");
            foreach (var product in Cart.Products)
            {
                Console.WriteLine($"- {product.Name} (السعر: {product.Price} ر.س)");
            }
            Console.WriteLine($"الإجمالي: {Cart.Products.Sum(p => p.Price)} ر.س");

            return View(Cart);
        }   

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public IActionResult UpdateCart(int productId, int quantity)
        //{
        //    try
        //    {
        //        var customerId = 4;
        //        var cart = _context.Carts
        //            .Include(c => c.Products)
        //            .FirstOrDefault(c => c.CustomerId == customerId);

        //        if (cart == null)
        //        {
        //            cart = new Cart { CustomerId = customerId };
        //            _context.Carts.Add(cart);
        //        }

        //        var product = _context.Products.Find(productId);
        //        if (product == null)
        //        {
        //            return NotFound();
        //        }

        //        // إضافة أو تحديث الكمية
        //        var existingProduct = cart.Products.FirstOrDefault(p => p.ProductId == productId);
        //        if (existingProduct != null)
        //        {
        //            // في حالتك الحالية، المنتجات لا تحتفظ بالكمية، لذا قد تحتاج لتعديل النموذج
        //            // هذا مثال افتراضي:
        //            // existingProduct.Quantity = quantity;
        //        }
        //        else
        //        {
        //            cart.Products.Add(product);
        //        }

        //        _context.SaveChanges();
        //        return RedirectToAction("Cart");
        //    }
        //    catch (Exception ex)
        //    {
        //        // تسجيل الخطأ
        //        return StatusCode(500, "حدث خطأ أثناء تحديث السلة");
        //    }
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public IActionResult ClearCart()
        //{
        //    try
        //    {
        //        var customerId = 4; // سيتم استبدالها بـ User ID بعد تنفيذ النظام
        //        var cart = _context.Carts
        //            .Include(c => c.Products)
        //            .FirstOrDefault(c => c.CustomerId == customerId);

        //        if (cart != null)
        //        {
        //            cart.Products.Clear();
        //            _context.SaveChanges();
        //        }

        //        return RedirectToAction("Cart");
        //    }
        //    catch (Exception ex)
        //    {
        //        // تسجيل الخطأ
        //        return StatusCode(500, "حدث خطأ أثناء إفراغ السلة");
        //    }
        //}
    }
}
