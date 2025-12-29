import 'package:flutter/material.dart';
import 'cart_manager.dart';
//import 'confirm.dart'; // For OrderConfirmationScreen

const Color appBrown = Color(0xFF443838);

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double subtotal = myCart.itemsPrice;
    double deliveryFee = 25.0;
    double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: appBrown,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Checkout", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Items List
                  for (var item in myCart.items)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.fastfood,
                                    color: Colors.grey[400]);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.qty} × \$${item.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "\$${(item.price * item.qty).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Price Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("Subtotal", subtotal),
                        const SizedBox(height: 8),
                        _buildPriceRow("Delivery Fee", deliveryFee),
                        const Divider(color: Colors.white54, height: 20),
                        _buildPriceRow("Total", total, isTotal: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Delivery Address
                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Home",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "123 Main Street, City, Country",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            // Navigate to address selection
                          },
                          child: const Text(
                            "Change Address",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Method
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.credit_card,
                              color: Colors.orange),
                          title: const Text("Credit/Debit Card"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaymentMethodScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(Icons.money, color: Colors.orange),
                          title: const Text("Cash on Delivery"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showCODConfirmation(context, total);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checkout Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a payment method"),
                    ),
                  );
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            color: isTotal ? Colors.orange : Colors.white,
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showCODConfirmation(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cash on Delivery"),
        content: Text(
          "You'll pay \$${total.toStringAsFixed(2)} when your order arrives.\n\nConfirm your order?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              myCart.clearCart();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
              );
            },
            child: const Text("Confirm Order"),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBrown,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title:
            const Text("Payment Method", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${(myCart.itemsPrice + 25.0).toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _buildPaymentCard(
              icon: Icons.credit_card,
              title: "Credit/Debit Card",
              subtitle: "Pay with Visa, MasterCard, or other cards",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CardScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildPaymentCard(
              icon: Icons.money,
              title: "Cash on Delivery",
              subtitle: "Pay when your order arrives",
              onTap: () {
                _showCODConfirmation(context);
              },
            ),
            const SizedBox(height: 16),
            _buildPaymentCard(
              icon: Icons.account_balance_wallet,
              title: "Digital Wallet",
              subtitle: "Google Pay, Apple Pay, etc.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Digital wallet payment coming soon!"),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(25),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: Colors.orange, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showCODConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cash on Delivery"),
        content: Text(
          "You'll pay \$${(myCart.itemsPrice + 25.0).toStringAsFixed(2)} when your order arrives.\n\nConfirm your order?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
              myCart.clearCart();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
              );
            },
            child: const Text("Confirm Order"),
          ),
        ],
      ),
    );
  }
}

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _holderController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    if (value.replaceAll(' ', '').length < 16) {
      return 'Enter a valid 16-digit card number';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
      return 'Use MM/YY format';
    }
    return null;
  }

  String? _validateHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card holder name is required';
    }
    return null;
  }

  String? _validateCVC(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVC is required';
    }
    if (value.length < 3) {
      return 'Enter 3-digit CVC';
    }
    return null;
  }

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isProcessing = false);

      myCart.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBrown,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Payment Details",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Card Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildCardField(
                controller: _cardNumberController,
                label: "Card Number",
                hint: "1234 5678 9012 3456",
                validator: _validateCardNumber,
                keyboardType: TextInputType.number,
                maxLength: 19,
                formatInput: (String? text) {
                  if (text == null) return '';
                  text = text.replaceAll(' ', '');
                  if (text.length > 4) {
                    text = '${text.substring(0, 4)} ${text.substring(4)}';
                  }
                  if (text.length > 9) {
                    text = '${text.substring(0, 9)} ${text.substring(9)}';
                  }
                  if (text.length > 14) {
                    text = '${text.substring(0, 14)} ${text.substring(14)}';
                  }
                  return text.substring(0, 19);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildCardField(
                      controller: _expiryController,
                      label: "Expiry Date",
                      hint: "MM/YY",
                      validator: _validateExpiry,
                      maxLength: 5,
                      formatInput: (String? text) {
                        if (text == null) return '';
                        if (text.length >= 2 && !text.contains('/')) {
                          return '${text.substring(0, 2)}/${text.substring(2)}';
                        }
                        return text.substring(0, 5);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCardField(
                      controller: _cvcController,
                      label: "CVC",
                      hint: "123",
                      validator: _validateCVC,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCardField(
                controller: _holderController,
                label: "Card Holder Name",
                hint: "John Doe",
                validator: _validateHolder,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _processPayment,
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Confirm Payment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    String? Function(String?)? formatInput,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            counterText: '',
          ),
          validator: validator,
          onChanged: formatInput != null
              ? (value) {
                  final formatted = formatInput(value);
                  if (formatted != value) {
                    controller.value = TextEditingValue(
                      text: formatted ?? '',
                      selection: TextSelection.collapsed(
                          offset: (formatted ?? '').length),
                    );
                  }
                }
              : null,
        ),
      ],
    );
  }
}

// Temporary: OrderConfirmationScreen class
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color appBrown = Color(0xFF443838);

    return Scaffold(
      backgroundColor: appBrown,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Order Confirmed!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your order has been placed successfully",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Order ID: #${DateTime.now().millisecondsSinceEpoch}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/map');
                  },
                  child: const Text(
                    "Track Your Order",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
