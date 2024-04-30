import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //حجات خاصة بس بال ios
import 'package:intl/intl.dart';
import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
 // var _title = '';
  final  _titleController = TextEditingController();
  final  _amountController = TextEditingController();
  final formatter = DateFormat.yMd();
   DateTime? _selectedDate ;
   Category _selectedCategory = Category.travel;




  @override
  void dispose() {
    // TODO: delete past after close app
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  void _showDialog(){
    Platform.isIOS?

    showCupertinoDialog(context: context, builder: (cxt) => CupertinoAlertDialog(
      title: const Text("Invalid Input"),
      content: const Text("Please make sure valid title, amount, date and category"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(cxt)
          , child:   const Text('OK'),),
      ],
    ),):
    showDialog(context: context,
      builder: (cxt) => AlertDialog(

        title: const Text("Invalid Input"),
        content: const Text("Please make sure valid title, amount, date and category"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(cxt)
            , child:   const Text('OK'),),
        ],

      ),);
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  // void saveTitle(String inputValue){
  // setState(() {
  //   _title = inputValue;
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox( //to make it responsive
      height: double.infinity, //to make it responsive
      child: SingleChildScrollView( //to make it responsive
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              controller: _titleController,
              //onChanged: saveTitle,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title')
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: '\$',
                        label: Text('Amount')
                    ),
                  ),
                ),
                const SizedBox(width: 16,),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text(_selectedDate== null? 'No date Selected ': formatter.format(_selectedDate!)),
                    IconButton(onPressed: () async{
                      final now =DateTime.now();
                      final firstDate = DateTime(now.year-1, now.month,now.day);

                     final DateTime? pickedDate = await showDatePicker(context: context, initialDate: now, lastDate: now, firstDate: firstDate);

                     setState(() {
                       _selectedDate = pickedDate;
                     });
                    }, icon: const Icon(Icons.calendar_month),),
                  ],),
                )
              ],
            ),
            const SizedBox(height:  20,),

            Row(children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((e) => DropdownMenuItem(
                value: e,
                child:
                Text(e.name.toUpperCase()),
              ),).toList(),
                onChanged: (newCat){
                if(newCat == null){
                  return;
                }
                setState(() {
                  _selectedCategory = newCat;
                });
                },),
              const Spacer(),
              TextButton(onPressed: ()=>Navigator.pop(context)
                , child: const Text('Cansle'),),

              ElevatedButton(onPressed: (){

                final double? enteredAmount = double.tryParse(_amountController.text);
                final bool amountIsInvalid = enteredAmount == null || enteredAmount <=0;

             //   const snackBar = SnackBar(content: Text('Error'));

                if(_titleController.text.trim().isEmpty  //trim لعدم قبول الفراغات
                            || amountIsInvalid
                    || _selectedDate==null){
                  _showDialog();

                } else {
                  widget.onAddExpense(Expense(category: _selectedCategory,
                      title: _titleController.text,
                      amount: enteredAmount,
                      date: _selectedDate!),);
                  Navigator.pop(context);

                }
              }, child: const Text('Save'))
            ],)
          ],),
        ),
      ),
    );
  }
}