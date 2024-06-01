import 'package:flutter/material.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({super.key, required this.imagesList});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _pageController=PageController();

  int index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: Column(
        children: [
          Center(
            child: Text("${index+1}/${widget.imagesList.length}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView(
              controller: _pageController,
              onPageChanged: (value){
                setState(() {
                  index=value;
                });
              },
              children: List.generate(
                widget.imagesList.length,
                (index) {
                  return InteractiveViewer(
                    transformationController: TransformationController(),
                    child: Image.network(
                      widget.imagesList[index],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    _pageController.jumpToPage(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    width: 150,
                    decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.yellow,),
                    borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(widget.imagesList[index].toString(),
                      fit: BoxFit.cover,),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
