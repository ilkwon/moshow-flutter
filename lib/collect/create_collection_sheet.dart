import 'package:flutter/material.dart';

class CreateCollectionSheet extends StatefulWidget {
  final Future<void> Function(String title, String tag) onCreated;
  const CreateCollectionSheet({super.key, required this.onCreated});

  @override
  State<CreateCollectionSheet> createState() => CreateCollectionSheetState();
}


class CreateCollectionSheetState extends State<CreateCollectionSheet> {
  final _titleController = TextEditingController();
  var _selectedTag = '공방';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('새 컬렉션',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: '컬렉션 이름'),
              ),
              const SizedBox(height: 16),
              _buildTagChips(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // 태그 선택 칩 (공방/클래스/스페이스/워크숍)
  Widget _buildTagChips() {
    return Wrap(
      spacing: 8,
      children: ['공방', '클래스', '스페이스', '워크숍'].map((tag) {
        final isSelected = tag == _selectedTag;
        return GestureDetector(
          onTap: () => setState(() => _selectedTag = tag),
          child: Chip(
            label: Text(tag),
            backgroundColor:
                isSelected ? const Color(0xFFD4A843) : const Color(0xFFEEEEEE),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF888888),
            ),
          ),
        );
      }).toList(),
    );
  }

  //----------------------------------------------------------------------------
  // 만들기 버튼 — 제목 없으면 동작 안 함
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_titleController.text.isEmpty) return;
          Navigator.pop(context);
          await widget.onCreated(_titleController.text, _selectedTag);
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A843)),
        child: const Text('만들기', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  //----------------------------------------------------------------------------
}