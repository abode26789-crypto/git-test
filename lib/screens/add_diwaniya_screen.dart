import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/facility.dart';
import '../widgets/app_widgets.dart';

class AddDiwaniyaScreen extends StatefulWidget {
  const AddDiwaniyaScreen({super.key});

  @override
  State<AddDiwaniyaScreen> createState() => _AddDiwaniyaScreenState();
}

class _AddDiwaniyaScreenState extends State<AddDiwaniyaScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedFacilities = {};
  final Set<int> _selectedPhotos = {};
  String _selectedType = 'مجلس عام';
  int _step = 0;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.green,
                size: 58,
              ),
              const SizedBox(height: 16),
              Text(
                'تم تجهيز الديوانية',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              const Text(
                'تم حفظ النموذج على هذا الجهاز للمعاينة فقط.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.brown),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'إضافة ديوانية أخرى',
                icon: Icons.add,
                onPressed: () => setState(() {
                  _step = 0;
                  _submitted = false;
                  _nameController.clear();
                  _locationController.clear();
                  _descriptionController.clear();
                  _selectedFacilities.clear();
                  _selectedPhotos.clear();
                  _selectedType = 'مجلس عام';
                }),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            children: [
              Text(
                'إضافة ديوانية',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'عرّف الناس على مجلسك',
                style: TextStyle(color: AppColors.brown),
              ),
              const SizedBox(height: 22),
              _StepIndicator(step: _step),
              const SizedBox(height: 24),
              if (_step == 0) _informationStep(),
              if (_step == 1) _facilitiesStep(),
              if (_step == 2) _photosStep(),
              if (_step == 3) _reviewStep(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 12),
          child: Row(
            children: [
              if (_step > 0) ...[
                IconButton.outlined(
                  tooltip: 'السابق',
                  onPressed: () => setState(() => _step--),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                const SizedBox(width: 9),
              ],
              Expanded(
                child: PrimaryButton(
                  key: ValueKey('add-step-$_step'),
                  label: _step == 3 ? 'حفظ للمعاينة' : 'التالي',
                  icon: _step == 3
                      ? Icons.check_rounded
                      : Icons.arrow_back_rounded,
                  onPressed: _continue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _informationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(label: 'اسم الديوانية'),
        const SizedBox(height: 7),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'مثال: ديوانية أبو محمد'),
        ),
        const SizedBox(height: 17),
        const _FieldLabel(label: 'الموقع'),
        const SizedBox(height: 7),
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            hintText: 'الحي، المدينة',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.green,
            ),
          ),
        ),
        const SizedBox(height: 17),
        const _FieldLabel(label: 'الوصف'),
        const SizedBox(height: 7),
        TextField(
          controller: _descriptionController,
          minLines: 3,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'اكتب نبذة قصيرة عن الديوانية',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 21),
        const _FieldLabel(label: 'نوع الديوانية'),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['مجلس عام', 'خاصة', 'بالدعوة', 'تحتاج موافقة']
              .map(
                (type) => _TypeChip(
                  label: type,
                  selected: _selectedType == type,
                  onTap: () => setState(() => _selectedType = type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _facilitiesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر المرافق المتوفرة',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 7),
        const Text(
          'يمكنك اختيار أكثر من مرفق',
          style: TextStyle(color: AppColors.brown, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 9,
          children: availableFacilities.map((facility) {
            final selected = _selectedFacilities.contains(facility.name);
            return FacilityChip(
              facility: facility,
              selected: selected,
              showIcon: true,
              onTap: () => setState(() {
                if (selected) {
                  _selectedFacilities.remove(facility.name);
                } else {
                  _selectedFacilities.add(facility.name);
                }
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _photosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صور الديوانية', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        const Text(
          'اختيارات توضيحية فقط، رفع الصور سيتاح لاحقاً',
          style: TextStyle(color: AppColors.brown, fontSize: 12),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 130,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final selected = _selectedPhotos.contains(index);
            return InkWell(
              onTap: () => setState(() {
                if (selected) {
                  _selectedPhotos.remove(index);
                } else {
                  _selectedPhotos.add(index);
                }
              }),
              borderRadius: BorderRadius.circular(13),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.placeholder,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected ? AppColors.green : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.photo_outlined,
                        color: AppColors.green,
                        size: 30,
                      ),
                    ),
                    if (selected)
                      const Positioned(
                        top: 7,
                        left: 7,
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.green,
                          size: 19,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _reviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مراجعة المعلومات', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 13),
        _ReviewRow(label: 'الاسم', value: _nameController.text),
        _ReviewRow(label: 'الموقع', value: _locationController.text),
        _ReviewRow(label: 'النوع', value: _selectedType),
        _ReviewRow(
          label: 'المرافق',
          value: _selectedFacilities.isEmpty
              ? 'لم يتم اختيار مرافق'
              : _selectedFacilities.join('، '),
        ),
        _ReviewRow(
          label: 'الصور التوضيحية',
          value: '${_selectedPhotos.length} صور',
        ),
        if (_descriptionController.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            _descriptionController.text,
            style: const TextStyle(color: AppColors.brown, height: 1.5),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'سيتم حفظ هذا النموذج محلياً للمعاينة. لا يتم نشره أو رفع الصور.',
          style: TextStyle(color: AppColors.brown, fontSize: 11),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    const steps = ['المعلومات', 'المرافق', 'الصور', 'المراجعة'];
    return Row(
      children: List.generate(steps.length, (index) {
        final active = index == step;
        final complete = index < step;
        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 1,
                    color: complete ? AppColors.green : AppColors.border,
                  ),
                ),
              Column(
                children: [
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: active || complete
                          ? AppColors.green
                          : AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active || complete
                            ? AppColors.green
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        complete ? '✓' : '${index + 1}',
                        style: TextStyle(
                          color: active || complete
                              ? AppColors.ivory
                              : AppColors.brown,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    steps[index],
                    style: TextStyle(
                      color: active ? AppColors.green : AppColors.brown,
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
  );
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    showCheckmark: false,
    selectedColor: AppColors.green,
    backgroundColor: AppColors.white,
    side: BorderSide(color: selected ? AppColors.green : AppColors.border),
    labelStyle: TextStyle(
      color: selected ? AppColors.ivory : AppColors.charcoal,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 84,
          child: Text(label, style: const TextStyle(color: AppColors.brown)),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? 'لم يحدد' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
