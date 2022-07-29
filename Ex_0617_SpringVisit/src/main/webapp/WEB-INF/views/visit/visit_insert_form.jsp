<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function send(f){
		
		//유효성체크 했다 치자...
		/* var photo = f.photo.value;
		if(photo == '') {
			alert(...)
		} */
		
		f.action = "insert.do";
		f.submit();
	}
</script>
</head>
<body> <!-- get방식으로 보내면 문자열로 보낸다.  -->
	<form method="post" enctype="multipart/form-data">
		<table border="1" align="center">
			<caption>:::새글 작성하기:::</caption>
			<tr>
				<th>작성자</th>
				<td><input name="name"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea row="5" cols="50" name="content" style="resize:none;"  wrap="on"></textarea></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input name="pwd" type="password"></td>
			</tr>
			<tr>
				<th>이미지 첨부</th>
				<td>
					<input type="file" name="photo">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" value="등록하기" onclick="send(this.form);">
					<input type="button" value="목록으로" onclick="location.href='list.do'">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>