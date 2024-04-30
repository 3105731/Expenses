import 'package:flutter/material.dart';
import 'package:n_app/widgets/new_expense.dart';
import '../chart/chart.dart';
import '../models/expense.dart';
import 'expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});



  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense>_registeredExpense = [

    Expense(
      category: Category.work,
      title: "Flutter Course",
      amount: 29.9,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.leisure,
      title: "Cinema",
      amount: 33.9456,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.food,
      title: "Breakfast",
      amount: 55,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.travel,
      title: "London",
      amount: 100.888,
      date: DateTime.now(),
    ),

  ];

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpense.add(expense);
    });

  }
  void _removeExpense(Expense expense){
    setState(() {
      _registeredExpense.remove(expense);
    });

  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width; //to make it responsive
    return Scaffold(
      appBar: AppBar(
        title:const Text("Flutter ExpenseTracker"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (c)=> NewExpense( onAddExpense: _addExpense),
            );
          }, icon: const Icon (Icons.add),),
        ],
      ),
      body: Center(
        child: width<600? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Chart(expenses: _registeredExpense)),
            Expanded(
              child: ExpensesList(
                expenses: _registeredExpense,
                onRemoveExpense: _removeExpense,),
            ),
          ],
        ):
        Row(  //to make it responsive
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Chart(expenses: _registeredExpense)),
            Expanded(
              child: ExpensesList(
                expenses: _registeredExpense,
                onRemoveExpense: _removeExpense,),
            ),



          ],
        ),
      ),
    );
  }
}

