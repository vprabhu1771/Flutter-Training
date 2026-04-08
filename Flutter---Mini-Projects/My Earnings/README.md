```dart
Widget _earningsSection(double amount) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Earning",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// GRID
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _earningBox(
                title: "Awaited PDD's",
                subtitle: "Expected Payout",
                amount: amount,
                isDark: true,
              ),
              _earningBox(
                title: "Ready for Invoice",
                subtitle: "Calculated Payout",
                amount: 0,
              ),
              _earningBox(
                title: "Awaited Payment",
                subtitle: "Confirmed Invoice",
                amount: 0,
              ),
              _earningBox(
                title: "Payment Received",
                subtitle: "Ledger (FY25-25)",
                amount: 900000,
                highlight: true,
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// BUTTONS
          Row(
            children: [
              Expanded(child: _actionButton("Payout Plan")),
              const SizedBox(width: 10),
              Expanded(child: _actionButton("Ledger")),
            ],
          )
        ],
      ),
    );
  }

  Widget _earningBox({
    required String title,
    required String subtitle,
    required double amount,
    bool isDark = false,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? Colors.black87
            : highlight
            ? Colors.orange.shade100
            : Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatToCrore(amount),
            style: TextStyle(
              color: highlight
                  ? Colors.deepOrange
                  : isDark
                  ? Colors.white
                  : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _formatToCrore(double amount) {
    if (amount >= 10000000) {
      return "₹ ${(amount / 10000000).toStringAsFixed(2)} Cr";
    } else if (amount >= 100000) {
      return "₹ ${(amount / 100000).toStringAsFixed(2)} L";
    } else {
      return "₹ ${amount.toStringAsFixed(0)}";
    }
  }

  Widget _actionButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
```