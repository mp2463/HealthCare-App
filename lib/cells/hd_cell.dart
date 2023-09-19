import 'package:flutter/material.dart';
import '../constants.dart';

class HDCell extends StatefulWidget {
  final valid;
  final name;
  final email;
  final specialist;
  final profileImage;
  final Function onTap;

  const HDCell({
    required this.valid,
    required this.name,
    required this.email,
    required this.specialist,
    required this.onTap,
    required this.profileImage,
  });

  @override
  State<HDCell> createState() => _HDCellState();
}

class _HDCellState extends State<HDCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        width: 283,
        height: 150,
        margin: EdgeInsets.only(left: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: SizedBox(
                width: 162,
                height: 139,
                child: Image(
                  image: AssetImage('assets/images/bg_shape.png'),
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.specialist + ' Specialist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 77,
                height: 54,
                decoration: BoxDecoration(
                  color: kPrimarydark,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(32)),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: kPrimaryLightColor,
                  size: 25,
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 10,
              bottom: 10,
              child: Container(
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                  child: widget.profileImage == false
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/images/account.png'),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(widget.profileImage),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
