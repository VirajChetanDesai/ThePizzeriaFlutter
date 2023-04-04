import 'package:flutter/material.dart';

class dropDown extends StatefulWidget {
  List<String> _dropdownItems;
  String selected;
  dropDown(this.selected,this._dropdownItems);
  @override
  State<dropDown> createState() => _dropDown();
}
class _dropDown extends State<dropDown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        alignedDropdown: true,
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          hint: Text(widget.selected,style: TextStyle(color: Colors.black),),
          icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
          iconSize: 18,
          isDense: true,
          borderRadius: BorderRadius.circular(10),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
          ),
          underline: Container(
            height: 0,
            color: Colors.black12,
          ),
          items: widget._dropdownItems.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? selectedItem) {
            setState(() {
              widget.selected = selectedItem!;
            });
          },
        ),
      ),
    );
  }
}
class cartItem extends StatefulWidget {
  int count = 0;
  String image;
  String pizza_name = '';
  double price = 0;
  List<String> base_size;
  List<String> base_style;
  cartItem(this.count,this.image,this.pizza_name,this.price,this.base_size,this.base_style);
  @override
  State<cartItem> createState() => _cartItemState();
}
class _cartItemState extends State<cartItem> {
  void _increment() {
    setState(() {
      if(widget.count<9) {
        widget.count++;
      }
    });
  }
  void _decrement() {
    setState(() {
      if(widget.count>1) {
        widget.count--;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(13.0),
              width: width,
              height: height/4.4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color(0xFFC4C4C4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: width/4,
                      height: height/6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [BoxShadow(
                          blurRadius: 0,
                          color: Colors.black26,
                          offset: Offset(0,5),
                        )],
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              width: width/3.8,
                              height:width/12,
                              padding: EdgeInsets.all(height * 0.01),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                    )
                                  ]),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${widget.pizza_name}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: width/3.8,
                              height: width/12,
                              padding: EdgeInsets.all(height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 0,
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: dropDown("Size",widget.base_size),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              width: width/3.8,
                              height: width/12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                    ),
                                  ]),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: IconButton(
                                        icon: Icon(Icons.remove,color: Colors.black,),
                                        iconSize: 10,
                                        padding: EdgeInsets.zero,
                                        onPressed: _decrement,
                                      ),
                                    ),
                                    Text('${widget.count}',style: TextStyle(color: Colors.black,fontSize: 12),),
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: IconButton(
                                        icon: Icon(Icons.add,color: Colors.black),
                                        iconSize: 10,
                                        padding: EdgeInsets.zero,
                                        onPressed: _increment,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: width/3.8,
                              height: width/12,
                              padding: EdgeInsets.all(height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 0,
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: dropDown("Style",widget.base_style),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),

                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              width: width/1.85,
                              height: width/12,
                              padding: EdgeInsets.all(height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 0,
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(child: Text("INR ${widget.price}",style: TextStyle(color: Colors.white),)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> allItems =[
  cartItem(1,'images/img.png','Sayuri-BTS',200,[ "Red",  "Blue",  "Green",],[ "S",  "M",  "L",],),
  cartItem(1,'images/img.png','Sayuri-BTS',300,[ "Red",  "Blue",  "Green",],[ "S",  "M",  "L",],),
];

class HomeFragmentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Home'),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: allItems,
        ),
      ),
    );
  }
}
