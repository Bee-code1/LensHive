import 'package:flutter/foundation.dart';

/// Cart item representing a product in the cart
@immutable
class CartItem {
  final String id;
  final String name;
  final String thumbnailUrl;
  final int quantity;
  final bool available;
  final int unitPricePkr;
  final bool selected;

  const CartItem({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.quantity,
    required this.available,
    required this.unitPricePkr,
    this.selected = false,
  });

  /// Total price for this line item
  int get totalPricePkr => unitPricePkr * quantity;

  /// Copy with method for immutability
  CartItem copyWith({
    String? id,
    String? name,
    String? thumbnailUrl,
    int? quantity,
    bool? available,
    int? unitPricePkr,
    bool? selected,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      quantity: quantity ?? this.quantity,
      available: available ?? this.available,
      unitPricePkr: unitPricePkr ?? this.unitPricePkr,
      selected: selected ?? this.selected,
    );
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      quantity: json['quantity'] as int,
      available: json['available'] as bool? ?? true,
      unitPricePkr: json['unitPricePkr'] as int,
      selected: json['selected'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnailUrl': thumbnailUrl,
      'quantity': quantity,
      'available': available,
      'unitPricePkr': unitPricePkr,
      'selected': selected,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          thumbnailUrl == other.thumbnailUrl &&
          quantity == other.quantity &&
          available == other.available &&
          unitPricePkr == other.unitPricePkr &&
          selected == other.selected;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      thumbnailUrl.hashCode ^
      quantity.hashCode ^
      available.hashCode ^
      unitPricePkr.hashCode ^
      selected.hashCode;
}

/// Cart containing all items and pricing details
@immutable
class Cart {
  final List<CartItem> items;
  final int subtotalPkr;
  final int discountPkr;
  final int shippingPkr;
  final int totalPkr;
  final bool hasBlockingIssue;

  const Cart({
    required this.items,
    required this.subtotalPkr,
    required this.discountPkr,
    required this.shippingPkr,
    required this.totalPkr,
    this.hasBlockingIssue = false,
  });

  /// Create empty cart
  factory Cart.empty() {
    return const Cart(
      items: [],
      subtotalPkr: 0,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: 0,
      hasBlockingIssue: false,
    );
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Get total item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get available items only
  List<CartItem> get availableItems =>
      items.where((item) => item.available).toList();

  /// Get unavailable items only
  List<CartItem> get unavailableItems =>
      items.where((item) => !item.available).toList();

  /// Check if any items are unavailable
  bool get hasUnavailableItems => unavailableItems.isNotEmpty;

  /// Copy with method for immutability
  Cart copyWith({
    List<CartItem>? items,
    int? subtotalPkr,
    int? discountPkr,
    int? shippingPkr,
    int? totalPkr,
    bool? hasBlockingIssue,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotalPkr: subtotalPkr ?? this.subtotalPkr,
      discountPkr: discountPkr ?? this.discountPkr,
      shippingPkr: shippingPkr ?? this.shippingPkr,
      totalPkr: totalPkr ?? this.totalPkr,
      hasBlockingIssue: hasBlockingIssue ?? this.hasBlockingIssue,
    );
  }

  /// Create from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotalPkr: json['subtotalPkr'] as int,
      discountPkr: json['discountPkr'] as int,
      shippingPkr: json['shippingPkr'] as int,
      totalPkr: json['totalPkr'] as int,
      hasBlockingIssue: json['hasBlockingIssue'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotalPkr': subtotalPkr,
      'discountPkr': discountPkr,
      'shippingPkr': shippingPkr,
      'totalPkr': totalPkr,
      'hasBlockingIssue': hasBlockingIssue,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart &&
          runtimeType == other.runtimeType &&
          listEquals(items, other.items) &&
          subtotalPkr == other.subtotalPkr &&
          discountPkr == other.discountPkr &&
          shippingPkr == other.shippingPkr &&
          totalPkr == other.totalPkr &&
          hasBlockingIssue == other.hasBlockingIssue;

  @override
  int get hashCode =>
      items.hashCode ^
      subtotalPkr.hashCode ^
      discountPkr.hashCode ^
      shippingPkr.hashCode ^
      totalPkr.hashCode ^
      hasBlockingIssue.hashCode;
}

