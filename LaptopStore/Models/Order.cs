using LaptopStore.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

public class Order
{
    public int OrderId { get; set; }

    [ForeignKey("Customer")]
    [Required]
    public int CustomerId { get; set; }

    public Customer Customer { get; set; } = new Customer();

    public DateTime OrderDate { get; set; } = DateTime.Now;

    [Range(0.01, double.MaxValue)]
    public decimal TotalAmount { get; set; }

    public string Status { get; set; } = "Pending";
    public string ShippingAddress { get; set; }
    public string PaymentMethod { get; set; }

    public List<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
}