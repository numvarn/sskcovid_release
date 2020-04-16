import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sskcovid19/cslib/sideMenu.dart';
import 'package:google_fonts/google_fonts.dart';


class AboutPage extends StatelessWidget {
  AboutPage({Key key}) : super(key: key);

  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle bulletStyle = GoogleFonts.prompt(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  TextStyle normStyle = GoogleFonts.prompt(
    fontSize: 15,
  );

  var sizeBox = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('ข้อมูลแอปพลิเคชัน', style: style),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("นโยบายความเป็นส่วนตัว", style: bulletStyle),
                  ),
                  SizedBox(height: sizeBox),
                  Text('"ผู้พัฒนา" และ "ผู้ดูแลระบบ" ให้ความสำคัญกับการเก็บรักษาข้อมูลส่วนบุคคลของผู้ใช้บริการ '
                      'โดยยึดมั่นในหลักการ การใช้ให้น้อยที่สุด ข้อมูลส่วนบุคคลของผู้ใช้บริการจะถูกเปิดใช้ในกรณีที่มีเหตุจำเป็นเท่านั้น '
                      'ผู้พัฒนาจะไม่เปิดเผยเหรือนำไปใช้ ซึ่งข้อมูลส่วนบุคคลของผู้ใช้บริการ ก่อนได้รับความยินยอมจากผู้ใช้บริการ '
                      'โดยข้อมูลใน "ศรีสะเกษสู้โควิด 19" จะถูกนำไปใช้เพื่อประกอบการการสืบค้นต้นหาตอการระบาดของเชื้อโควิด 19 '
                      'และเพื่อแจ้งเตือนให้แก่ผู้ใช้บริการท่านอื่น ๆ ในะบบ',
                      style: normStyle,
                  ),

                  SizedBox(height: sizeBox),
                  Text('"ผู้พัฒนา" และ "ผู้ดูแลระบบ" รับรองว่าข้อมูลที่จัดเก็บทั้งหมดจะถูกจัดเก็บอย่างปลอดภัย เราปกป้อง '
                      'และป้องกันข้อมูลส่วนตัวของผู้ใช้บริการโดย ',
                      style: normStyle),

                  SizedBox(height: sizeBox),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text('จำกัดการเข้าถึงข้อมูลส่วนตัว', style: normStyle),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text('จัดให้มีวิธีการทางเทคโนโลยีเพื่อป้องกันไม่ให้มีการเข้าสู่ระบบคอมพิวเตอร์ที่'
                        'ไม่ได้รับอนุญาต ตลอดจนการเข้ารหัสข้อมูล',
                        style: normStyle),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'หากผู้ใช้บริการพบปัญหา หรือ ช่องโหว่ด้านความปลอดภัย '
                            'ตลอดจนเหตุให้เชื่อว่าความเป็นส่วนตัวได้ถูกละเมิด กรุณาติดต่อ “ดูแลระบบ” '
                            'เพื่อทำการตรวจสอบและแก้ไขปัญหาดังกล่าว',
                        style: normStyle),
                  ),

                  SizedBox(height: sizeBox),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ข้อมูลส่วนตัวและบัญชีส่วนตัว", style: bulletStyle),
                  ),

                  SizedBox(height: sizeBox),
                  Text(
                      'เมื่อผู้ใช้บริการสร้างบัญชีผู้ใช้งาน เพื่อใช้บริการ "ศรีสะเกษสู้โควิด 19" '
                      '"ผู้พัฒนา" จะทำการจัดเก็บข้อมูลส่วนตัวต่าง ๆ แต่ไม่จำกัดเฉพาะข้อมูลเหล่านี้ของผู้ใช้บริการ',
                      style: normStyle
                  ),

                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'ชื่อ - นามสกุล',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'อีเมล',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'ข้อมูลที่ทำงาน',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'ข้อมูลที่อยู่ปัจจุบัน',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'ข้อมูลพิกัดตำแหน่ง',
                        style: normStyle
                    ),
                  ),

                  SizedBox(height: sizeBox),
                  Text(
                      'ข้อมูลที่ผู้ใช้บริการได้ทำการส่งมอบให้ระบบ '
                          'ผ่านช่องทางต่าง ๆ เช่น การกรอกข้อมูลใน "ศรีสะเกษสู้โควิด 19" '
                          'จะถูกจัดเก็บในระบบ ผู้ใช้บริการมีหน้าที่รับผิดชอบในการส่งมอบข้อมูลที่ถูกต้อง',
                      style: normStyle),

                  SizedBox(height: sizeBox),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ข้อมูลผู้พัฒนา", style: bulletStyle),
                  ),
                  SizedBox(height: sizeBox),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'อาจารย์พิศาล สุขขี',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'สาขาวิทยาการคอมพิวเตอร์',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'มหาวิทยาลัยราชภัฏศรีสะเกษ',
                        style: normStyle
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: new Text(
                        'email : phisan.s@sskru.ac.th',
                        style: normStyle
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 20.0,
      width: 20.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}