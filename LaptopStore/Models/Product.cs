using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    public class Product
    {
        [Key]
        public int ProductId { get; set; }

        [Required(ErrorMessage = "اسم المنتج مطلوب")]
        [StringLength(100, ErrorMessage = "يجب ألا يتجاوز الاسم 100 حرف")]
        public string Name { get; set; }

        public string Description { get; set; }

        [Required(ErrorMessage = "الفئة مطلوبة")]
        public int CategoryId { get; set; }

        [ForeignKey("CategoryId")]
        public Category Category { get; set; }

        [Required(ErrorMessage = "المورد مطلوب")]
        public int SupplierId { get; set; }

        [ForeignKey("SupplierId")]
        public Supplier Supplier { get; set; }

        [Required(ErrorMessage = "السعر مطلوب")]
        [Column(TypeName = "decimal(10,2)")]
        [Range(0.01, double.MaxValue, ErrorMessage = "يجب أن يكون السعر أكبر من الصفر")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "الكمية المتاحة مطلوبة")]
        public int StockQuantity { get; set; } = 0;

        public string ImageUrl { get; set; }

        [Column(TypeName = "json")]
        public string Specifications { get; set; }  // تخزين كـ JSON

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;

        [Column(TypeName = "decimal(3,2)")]
        public decimal Rating { get; set; } = 0.00m;

        public int ReviewCount { get; set; } = 0;

        public bool IsOnSale { get; set; } = false;

        [Column(TypeName = "decimal(10,2)")]
        public decimal? SalePrice { get; set; }  // يمكن أن يكون null
    }
}