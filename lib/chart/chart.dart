
import 'package:flutter/material.dart';
import 'package:n_app/chart/chart_bar.dart';

import '../models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses,});

  final List<Expense>expenses;

  List<ExpenseBucket> get bucket{
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.work),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.leisure),
    ];
  }

  double get maxTotalExpense{
    double maxTotalExpense = 0;
    for (var element in bucket) {
     if(element.totalExpense > maxTotalExpense){
       maxTotalExpense = element.totalExpense;
     }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return LayoutBuilder(
      builder: (ctx,constraint){
        return  Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
          width: double.infinity,
          height: constraint.maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(colors:[
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.primary.withOpacity(0.0),
            ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(children: [
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                for(final ele in bucket) ChartBar(fill: ele.totalExpense==0?0
                    :ele.totalExpense/maxTotalExpense,),
              ],),),
            const SizedBox(height: 12,),

            Row(children: bucket.map((e)=> Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(categoryIcons[e.category],
                color:  isDarkMode?
                Theme.of(context).colorScheme.primary:
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ),))).toList(),
            ),

          ],),
        );
      },

    );
  }
}