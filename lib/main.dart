import 'package:example1/transfer.dart';
import 'package:example1/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AutorizationScreen(),
    );
  }
}

class AutorizationScreen extends StatefulWidget {
  const AutorizationScreen({super.key});

  @override
  State<AutorizationScreen> createState() => _AutorizationScreenState();
}

class _AutorizationScreenState extends State<AutorizationScreen> {
  Color navbarColor = Color(0xfffef0ef);
  int selectedIndex = 0;
  bool isLoading = true;

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    setLoading();
  }

  void setLoading() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Autorizar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: navbarColor,
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        elevation: 0,
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: [
              TabItem(title: 'Pendientes', value: 100),
              TabItem(title: 'Autorizados', value: 50),
              TabItem(title: 'Rechazados', value: 20),
            ],
            onTabChanged: (index) {
              setState(() {
                selectedIndex = index;
              });

              setLoading();
            },
          ),
          SizedBox(height: 20),
          returnWidget(context: context, index: selectedIndex),
        ],
      ),
    );
  }

  Widget returnWidget({required BuildContext context, required int index}) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildWidgetForIndex(context, index),
    );
  }

  Widget _buildWidgetForIndex(BuildContext context, int index) {
    if (index == 0) {
      return Skeletonizer(
        key: ValueKey('pendientesWidget'),
        enabled: isLoading,
        child: pendientesWidget(context: context),
      );
    }
    if (index == 1) {
      return Skeletonizer(
        key: ValueKey('autorizadosWidget'),
        enabled: isLoading,
        child: pendientesWidget(context: context),
      );
    }
    if (index == 2) {
      return Skeletonizer(
        key: ValueKey('rechazadosWidget'),
        enabled: isLoading,
        child: pendientesWidget(context: context),
      );
    }

    return SizedBox();
  }
}

Widget pendientesWidget({
  required BuildContext context,
}) => SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(
        height: 50,
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(width: 10),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: index == 0 ? Colors.purple[900] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Visibility(
                    visible: index == 0,
                    child: Icon(Icons.arrow_downward, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Fechas ${index + 1}',
                    style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Visibility(
                    visible: index == 0,
                    child: Icon(Icons.arrow_circle_down, color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      SizedBox(height: 30),
      GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15 jun'),
              Text(
                'Seleccionar todos',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Papeleria Industrial mex **123',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$123.00 MXN'),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      'Transferencia',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Transfer()),
          );
        },
        title: Text(
          'Alta masiva de benefecios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('5,000'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                'Beneficiarios',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        leading: Checkbox(value: false, onChanged: (value) {}),
        trailing: Icon(Icons.arrow_forward_ios),
        isThreeLine: true,
      ),
      Divider(color: Colors.grey[300]!, height: 1),
      SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Pago de nomina',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$123.00 MXN'),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      'Pago de nomina',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    ],
  ),
);
