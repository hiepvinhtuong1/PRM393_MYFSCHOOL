# Tài liệu Tích hợp API Đơn Xin Nghỉ Học (Dành cho Flutter Mobile App)

Tài liệu này cung cấp chi tiết danh sách các Endpoint Backend Spring Boot và định dạng dữ liệu (JSON Format) để team Flutter (Parent App) dễ dàng thực hiện mapping data và thiết kế các màn hình tương ứng.

## 1. Cấu hình chung

*   **Base URL (Môi trường Dev):** `http://<IP_MÁY_CHỦ>:8080/api/v1`
*   **Authentication:** Yêu cầu header `Authorization: Bearer <JWT_TOKEN>`. Token này có role `PARENT`.
*   **Định dạng chung (Response Wrapper):** Tất cả các API trả về đều được bọc trong `ApiResponse`.
    ```json
    {
      "success": true,
      "message": "Thành công",
      "data": { ... } 
    }
    ```

---

## 2. Danh sách APIs cho Phụ huynh (Parent Role)

### 2.1. Lấy danh sách lịch sử Đơn xin nghỉ của 1 Học sinh
*   **Endpoint:** `GET /me/students/{studentId}/leave-requests`
*   **Mô tả:** Lấy danh sách đơn xin nghỉ kèm phân trang. Mặc định sắp xếp mới nhất lên đầu.
*   **Tham số (Query Params):**
    *   `page` (int): Số trang (Bắt đầu từ 0). Mặc định: 0.
    *   `size` (int): Số dòng trên mỗi trang. Mặc định: 20.
*   **Response (JSON - HTTP 200):**
    Trường `data` là một `PageResponse` chứa mảng các `LeaveRequest`.
    ```json
    {
      "success": true,
      "data": {
        "content": [
          {
            "id": 1,
            "studentId": 100,
            "studentName": "Nguyễn Văn A",
            "requestType": "ONE_DAY",
            "startDate": "2026-10-15",
            "endDate": "2026-10-15",
            "reason": "Cháu bị sốt cao",
            "status": "PENDING",
            "rejectionReason": null,
            "reviewedByTeacherName": null,
            "createdAt": "2026-10-14T08:30:00",
            "lessonIds": [1, 2, 3]
          }
        ],
        "pageNumber": 0,
        "pageSize": 20,
        "totalElements": 1,
        "totalPages": 1,
        "last": true
      }
    }
    ```

### 2.2. Tạo mới Đơn xin nghỉ
*   **Endpoint:** `POST /me/students/{studentId}/leave-requests`
*   **Mô tả:** Phụ huynh gửi đơn xin nghỉ cho học sinh.
*   **Request Body (JSON):**
    ```json
    {
      "requestType": "ONE_DAY", 
      "startDate": "2026-10-15",
      "endDate": "2026-10-15",
      "reason": "Cháu bị ốm",
      "lessonIds": [1, 2] // Chỉ truyền mảng lessonIds nếu requestType là ONE_DAY
    }
    ```
    *Ghi chú: Nếu `requestType` là `MULTIPLE_DAYS`, bạn bỏ mảng `lessonIds` đi, chỉ truyền `startDate` và `endDate` khác nhau.*
*   **Response (JSON - HTTP 201):**
    Trả về chi tiết đơn vừa được tạo.

### 2.3. Hủy đơn xin nghỉ
*   **Endpoint:** `DELETE /me/students/{studentId}/leave-requests/{id}`
*   **Mô tả:** Hủy đơn xin nghỉ. Chỉ có thể hủy khi đơn đang ở trạng thái `PENDING`.
*   **Response (JSON - HTTP 200):**
    Trả về chi tiết đơn đã chuyển sang trạng thái `CANCELLED`.

---

## 3. Hướng dẫn Mapping Data (Dành cho Dart / Flutter)

Để dễ dàng ánh xạ dữ liệu, team Flutter nên tạo các Enums và Models tương ứng sau:

### Enums
```dart
enum LeaveRequestStatus {
  PENDING,    // Đang chờ duyệt (Màu Vàng cam)
  APPROVED,   // Đã duyệt (Màu Xanh lá)
  REJECTED,   // Bị từ chối (Màu Đỏ)
  CANCELLED   // Đã hủy (Màu Xám)
}

enum LeaveRequestType {
  ONE_DAY,        // Nghỉ 1 ngày (theo tiết học cụ thể)
  MULTIPLE_DAYS   // Nghỉ nhiều ngày liên tiếp
}
```

### Dart Model
```dart
class LeaveRequest {
  final int id;
  final int studentId;
  final String studentName;
  final LeaveRequestType requestType;
  final String startDate; // Format: yyyy-MM-dd
  final String endDate;   // Format: yyyy-MM-dd
  final String reason;
  final LeaveRequestStatus status;
  final String? rejectionReason;
  final String? reviewedByTeacherName;
  final String createdAt;
  final List<int>? lessonIds;

  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.requestType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.rejectionReason,
    this.reviewedByTeacherName,
    required this.createdAt,
    this.lessonIds,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      requestType: LeaveRequestType.values.byName(json['requestType']),
      startDate: json['startDate'],
      endDate: json['endDate'],
      reason: json['reason'],
      status: LeaveRequestStatus.values.byName(json['status']),
      rejectionReason: json['rejectionReason'],
      reviewedByTeacherName: json['reviewedByTeacherName'],
      createdAt: json['createdAt'],
      lessonIds: json['lessonIds'] != null ? List<int>.from(json['lessonIds']) : null,
    );
  }
}
```

### Xử lý Hiển thị UI trên Flutter
1.  **Lịch sử đơn:** Sử dụng `ListView.builder` kết hợp Pull-to-refresh để gọi API `GET /.../leave-requests`.
2.  **Trạng thái (Badge/Chip):** Xây dựng một helper method để đổi màu sắc (Color) tuỳ theo `status`. Ví dụ: `PENDING` màu Cam, `APPROVED` màu Xanh, có thể dùng thuộc tính `color` trong Flutter để tô màu cho Chip widget.
3.  **Hủy đơn:** Gắn action xoá (Icon thùng rác hoặc nút "Hủy đơn") chỉ khi `status == LeaveRequestStatus.PENDING`.
4.  **Lý do từ chối:** Nếu `status == LeaveRequestStatus.REJECTED`, hãy hiển thị thêm đoạn text cho biến `rejectionReason` (màu đỏ) phía dưới cùng của Card.
