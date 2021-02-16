import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_project/layout/layout_screen.dart';
import 'package:food_project/screens/cart/cubit/cubit.dart';
import 'package:food_project/screens/cart/cubit/states.dart';
import 'package:food_project/shared/colors/colors.dart';
import 'package:food_project/shared/componentes/components.dart';
import 'dart:core';

class CartScreen extends StatelessWidget {

  getTotalPrice(List carts , int price2){
    int price = 0 ;
    if (carts.length != 0){
      for(var i = 1 ; i <= carts.length ; i++ ){
        price = price + price2 ;
      }
      return price ;
    }
   else{
     return price ;
    }
  }

  getIndex(List carts){
    int index = 0 ;
    if (carts.length != 0){
      for(var i = 0  ; i < carts.length ; i++ ){
       index = i ;
      }
      return index ;
    }
    else{
      return 0 ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..showCart(),
      child: BlocConsumer<CartCubit, CartStates>(
        listener: (context, state) {
          if (state is ShowCartStateLoading) {
            print('ShowCartStateLoading');
            return buildProgress(
                context: context,
                text: "please Wait until creating an account.. ");
          }
          if (state is ShowCartStateSuccess) {
            print('ShowCartStateSuccess');
          }
          if (state is ShowCartStateError) {
            print('ShowCartStateError');
            Navigator.pop(context);
            return buildProgress(
              context: context,
              text: "${state.error.toString()}",
              error: true,
            );
          }
        },
        builder: (context, state) {
          List cartMeals = CartCubit.get(context).cartMeals;
          List cartMealsId = CartCubit.get(context).cartMealsId;
          List cartMealsPrices = cartMeals.reversed.toList() ;
          return ConditionalBuilder(
            condition: state is ShowCartStateLoading,
            builder: (context) => Center(child: CircularProgressIndicator()),
            fallback: (context) => Scaffold(
              body: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: defaultColor,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${cartMeals[index]['imageLink']}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        width: 100,
                                        height: 100,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${cartMeals[index]['MealTitle']}',
                                              style: TextStyle(fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '${cartMeals[index]['MealPrice']} L.E',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                'Category: ${cartMeals[index]['MealCategory']}'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         IconButton(
                                             icon: Icon(Icons.delete,color: Colors.red,),
                                             onPressed: (){
                                               CartCubit.get(context).deleteMeal(documentId: cartMealsId , index: index);
                                               navigateTo(context, LayoutScreen());
                                               },
                                         ),
                                       ],
                                     )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20.0,
                    ),
                    itemCount: cartMeals.length,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              if(cartMeals.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: defaultButton(
                    function: (){},
                      text: 'PRoceed to checkout',
                      background: Colors.green,
                  ),
                ),
              ]
              ),
            ),
          );
        },
      ),
    );
  }
}
