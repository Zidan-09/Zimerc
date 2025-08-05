// lib/screens/general/products/widgets/add_product_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constants.dart';
import '../../../../services/product_service.dart';
import '../../../../services/session.dart';

class AddProductForm extends StatefulWidget {
  /// Optional callback called após adicionar (antes de fechar o modal)
  final VoidCallback? onAdded;

  const AddProductForm({super.key, this.onAdded});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  final ProductService _productService = ProductService();
  final Session _session = Session();

  bool _isLoading = false;

  bool get _isAmbulant => _session.isAmbulant;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameCtrl.text.trim();
      // Aceita vírgula ou ponto — converte para ponto antes do parse
      final priceText = _priceCtrl.text.trim().replaceAll(',', '.');
      final unitPrice = double.tryParse(priceText) ?? 0.0;

      int? stockQuantity;
      if (!_isAmbulant) {
        final qText = _qtyCtrl.text.trim();
        stockQuantity = qText.isEmpty ? null : int.tryParse(qText);
      }

      // tenta recuperar user_id (Session salva como String)
      int? userId = _session.userId != null ? int.tryParse(_session.userId!) : null;

      final productMap = <String, dynamic>{
        'name': name,
        'unit_price': unitPrice,
        // só adiciona stock_quantity quando não for ambulant
        if (!_isAmbulant) 'stock_quantity': stockQuantity ?? 0,
        'company_id': null,
        'user_id': userId,
        'is_synced': 0,
      };

      await _productService.addProduct(productMap);

      // callback opcional
      widget.onAdded?.call();

      // mostra mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto adicionado com sucesso')),
        );
        // fecha modal e retorna true para quem abriu
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar produto: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Para que o bottom sheet se ajuste ao teclado
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header / handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Adicionar Produto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Nome
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha o nome';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Preço
                TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preço (ex: 10,00)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha o preço';
                    final parsed = double.tryParse(v.replaceAll(',', '.'));
                    if (parsed == null) return 'Preço inválido';
                    if (parsed <= 0) return 'Preço deve ser maior que zero';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Quantidade (somente se NÃO for AMBULANT)
                if (!_isAmbulant) ...[
                  TextFormField(
                    controller: _qtyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade em estoque',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Preencha a quantidade';
                      final parsed = int.tryParse(v);
                      if (parsed == null) return 'Quantidade inválida';
                      if (parsed < 0) return 'Quantidade inválida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Botão adicionar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Adicionar', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}