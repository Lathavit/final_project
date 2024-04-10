import 'package:flutter/material.dart';
import '../../helpers/color_utils.dart';
import '../../helpers/my_text_field.dart';
import '../main/home_page.dart';
import 'package:dio/dio.dart';
import 'package:bcrypt/bcrypt.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String statusEvent = "init";
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conpass = TextEditingController();

  bool register = false;
  bool _passwordVisible = false;

  String link = "http://localhost:3000";

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color darkenedColor = darken(primaryColor, 30);

    return MaterialApp(
      title: 'Silpakorn Faculty',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: darkenedColor,
          title: Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: statusEvent == "loading"
              ? const CircularProgressIndicator()
              : display(),
        ),
      ),
    );
  }

  Scaffold display() {
    Color primaryColor = Theme.of(context).primaryColor;
    Color darkenedColor = darken(primaryColor, 30);
    Color lightenedColor = lighten(primaryColor, 90);
    return Scaffold(
      body: Container(
        color: lightenedColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyTextField(
              controller: name,
              labelText: 'Username',
              showSuffixIcon: false,
              passwordVisible: false,
            ),
            SizedBox(height: 20.0),
            MyTextField(
              controller: pass,
              labelText: 'Password',
              showSuffixIcon: register ? false : true,
              suffixIcon:
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
              suffixIconOnPressed: togglePasswordVisibility,
              passwordVisible: register ? true : _passwordVisible,
              enableObscureText: true,
            ),
            Column(
              children: [
                if (register) SizedBox(height: 20.0),
                if (register)
                  MyTextField(
                    controller: conpass,
                    labelText: 'Confirm Password',
                    showSuffixIcon: false,
                    passwordVisible: true,
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: register ? regist : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkenedColor,
              ),
              child: Text(
                register ? "Regist" : "Login",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            InkWell(
              onTap: () => setState(() {
                register = !register;
                name.clear();
                pass.clear();
                conpass.clear();
              }),
              child: Text(
                register ? 'มีรหัสแล้ว' : 'ยังไม่มีรหัส?',
                style: const TextStyle(
                    color: Colors.purple, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }

  String bCryptHash(String password) {
    final String passwordHashed = BCrypt.hashpw(
      password,
      BCrypt.gensalt(),
    );
    return passwordHashed;
  }

  void regist() async {
    statusEvent = "loading";
    setState(() {});

    bool handle = pass.text.trim() == conpass.text.trim() &&
        pass.text.trim().isNotEmpty &&
        name.text.trim().isNotEmpty;

    if (handle) {
      try {
        final response = await Dio().post(
          '${link}/regist',
          data: {
            "userName": name.text.trim(),
            "password": bCryptHash(pass.text.trim())
          },
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        if (response.statusCode == 200) {
          String status = response.data['status'];
          status == "success"
              ? _showPopup("สร้าง ID สำเร็จ")
              : _showPopup("มี username นี้แล้ว");
        } else {
          _showPopup("ไม่สามารถเชื่อมต่อ server ได้");
        }
      } catch (e) {
        print(e.toString());
        _showPopup("ไม่สามารถเชื่อมต่อ server ได้");
      }
    } else {
      _showPopup("รหัสไม่ตรงกัน หรือ ไม่มีการใส่ข้อมูล");
    }

    statusEvent = "finished";
    setState(() {});
  }

  void login() async {
    statusEvent = "loading";
    setState(() {});

    try {
      final response = await Dio().post(
        '${link}/login',
        data: {"userName": name.text.trim()},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        String status = response.data['status'];
        if (status != 'failure') {
          String obj = response.data['hash'];
          final bool checkPassword = BCrypt.checkpw(pass.text.trim(), obj);
          checkPassword
              ? _showPopup("Login successful")
              : _showPopup("รหัสไม่ถูกต้อง");
          if (checkPassword) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        } else {
          _showPopup("ไม่พบชื่อผู้ใช้");
        }
      } else {
        _showPopup("ไม่สามารถเชื่อมต่อ server ได้");
      }
    } catch (e) {
      print(e.toString());
      _showPopup("ไม่สามารถเชื่อมต่อ server ได้");
    }

    statusEvent = "finished";
    setState(() {});
  }

  void togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
