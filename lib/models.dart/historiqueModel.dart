import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/Usermodel.dart';

class ActionItem {
  final String? id;
  final String? itemId;
  final int? quantity;
  final String? userId;
  final DateTime? createdAt;
  final String? action;
  final OldValue? oldValue;
  final NewValue? newValue;
  final Item? item;
  final User? user;

  ActionItem({
    this.id,
    this.itemId,
    this.quantity,
    this.userId,
    this.createdAt,
    this.action,
    this.oldValue,
    this.newValue,
    this.item,
    this.user,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'],
      itemId: json['itemId'],
      quantity: json['quantity'],
      userId: json['userId'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      action: json['action'],
      oldValue: json['oldValue'] != null ? OldValue.fromJson(json['oldValue']) : null,
      newValue: json['newValue'] != null ? NewValue.fromJson(json['newValue']) : null,
      item: json['item'] != null ? Item.fromJson(json['item']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Color get actionColor {
    return {
      // 'Added new': Colors.green,
      'RemovedFromStock': Colors.orange,
      'Deleted': Colors.red,
      'Updated': Colors.blue,
      'Added To Stock': Colors.yellow,
    }[action] ?? Colors.grey;
  }

  IconData get actionIcon {
    return {
      // 'Added new': Icons.add,
      'RemovedFromStock': Icons.remove_outlined,
      'Deleted': Icons.delete_outline,
      'Updated': Icons.update,
      'Added To Stock': Icons.add,
    }[action] ?? Icons.info_outline;
  }

  String get title => item?.name ?? 'Produit inconnu';

  String get details {
    switch (action) {
      // case 'Added new':
      //   return '➕ $quantity unités ajoutées à ${item?.unitPrice?.toStringAsFixed(2) ?? 'N/A'} FCFA/unité';
      case 'RemovedFromStock':
        return '🔻 $quantity unités retirées (Ancien stock: ${oldValue?.quantity ?? 0} → Nouveau stock: ${newValue?.quantity ?? 0})';
      case 'Deleted':
        return '❌ Produit supprimé';
      case 'Updated':
        return '🔄 Produit mis à jour : ${updatedDetails}';
      case 'Added To Stock':
        return '🔻 $quantity unités ajoutées (Ancien stock: ${oldValue?.quantity ?? 0} → Nouveau stock: ${newValue?.quantity ?? 0})';
      default:
        return '⚠️ Action inconnue';
    }
  }

  String get updatedDetails {
    List<String> changes = [];
    if (oldValue?.quantity != newValue?.quantity) {
      changes.add('Quantité: ${oldValue?.quantity ?? 0} → ${newValue?.quantity ?? 0}');
    }
    if (oldValue?.name != newValue?.name) {
      changes.add('Nom: ${oldValue?.name ?? 'Inconnu'} → ${newValue?.name ?? 'Inconnu'}');
    }
    if (oldValue?.unitPrice != newValue?.unitPrice) {
      changes.add('Prix: ${oldValue?.unitPrice?.toStringAsFixed(2) ?? 'N/A'} FCFA → ${newValue?.unitPrice?.toStringAsFixed(2) ?? 'N/A'} FCFA');
    }
    return changes.isNotEmpty ? changes.join(', ') : 'Aucune modification détectée';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'quantity': quantity,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'action': action,
      'oldValue': oldValue?.toJson(),
      'newValue': newValue?.toJson(),
      'item': item?.toJson(),
      'user': user?.toJson(),
    };
  }
}

class OldValue {
  final int? quantity;
  final String? name;
  final int? unitPrice;
  final User? user;

  const OldValue(this.name, this.unitPrice, this.user, {this.quantity});

  factory OldValue.fromJson(Map<String, dynamic> json) {
    return OldValue(
      json['name'],
      (json['unitPrice'] as num?)?.toInt(),
      json['user'] != null ? User.fromJson(json['user']) : null,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'unitPrice': unitPrice,
      'user': user?.toJson(),
    };
  }
}

class NewValue {
  final int? quantity;
  final String? name;
  final int? unitPrice;

  const NewValue({this.quantity, this.name, this.unitPrice});

  factory NewValue.fromJson(Map<String, dynamic> json) {
    return NewValue(
      quantity: json['quantity'],
      name: json['name'],
      unitPrice: (json['unitPrice'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'unitPrice': unitPrice,
    };
  }
}
