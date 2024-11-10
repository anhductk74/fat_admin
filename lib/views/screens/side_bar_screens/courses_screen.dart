import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseScreen extends StatelessWidget {
  static const String routeName = '/CourseScreen';

  // Hàm để xóa tài liệu khỏi Firestore
  void deleteCourse(String courseId) {
    FirebaseFirestore.instance.collection('Courses').doc(courseId).delete();
  }

  // Hàm để điều hướng đến màn hình sửa hoặc mở hộp thoại
  void editCourse(BuildContext context, DocumentSnapshot course) {
    // Mở hộp thoại hoặc điều hướng đến màn hình sửa chi tiết ở đây
    // Ví dụ: Navigator.pushNamed(context, EditCourseScreen.routeName, arguments: course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Courses'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No courses available.'));
          }

          var courses = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FlexColumnWidth(0.5), // Cột "Tên khóa học"
                  1: FlexColumnWidth(2), // Cột "Giáo viên"
                  2: FlexColumnWidth(2), // Cột "Thời lượng"
                  3: FlexColumnWidth(1), // Cột "Sửa"
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                  6: FlexColumnWidth(1), // Cột "Xóa"
                },
                children: [
                  // Hàng tiêu đề
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Course Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Teacher',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Hiển thị dữ liệu từ Firebase
                  ...courses.map((course) {
                    var data = course.data() as Map<String, dynamic>;
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            // Thêm widget Center để căn giữa text
                            child: Text(
                              data['id']?.toString() ?? 'N/A',
                              textAlign: TextAlign
                                  .center, // Căn giữa text theo chiều ngang
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['subject'] ?? 'N/A'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['teacher'] ?? 'N/A'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['price']?.toString() ?? 'N/A'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['description'] ?? 'N/A'),
                        ),
                        // Nút Sửa
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editCourse(context, course),
                          ),
                        ),
                        // Nút Xóa
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteCourse(course.id);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
