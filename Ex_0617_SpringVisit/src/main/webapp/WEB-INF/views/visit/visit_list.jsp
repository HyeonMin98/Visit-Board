<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title> <!-- webapp폴더까지의 경로 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/visit.css">
<script src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>
<script>
	function del(f){
		var pwd = f.pwd.value;
		if(pwd ==''){
			alert("비밀번호를 입력하세요")
			return;
		}
		
		if(!confirm("삭제하시겠습니까?")){
			return;
		}
		
		var url = "delete.do";
		var param = "idx="+f.idx.value+"&pwd="+encodeURIComponent(pwd);
		
		sendRequest(url,param,resultFn,"post");
	}
	
	function resultFn(){
		if(xhr.readyState == 4 && xhr.status== 200){
						//"[{'res':'yes'}]"
			var data = xhr.responseText;
			var json = (new Function('return'+data))();//eval(data); eval이 제이슨표기법만을 위해서 사용되는게 아니라 페이지에 대한 정보라던지 용도가 많다. 그래서 외부에서 접근하기가 쉬워서 보안성이 좋지 않다.
			
			if(json[0].res == 'no'){
				alert("삭제실패");
				return;
			} 
				alert("삭제성공");
				location.href="list.do";
			
		}
	}
	
	function modify(f){
		var ori_pwd = f.ori_pwd.value.trim(); //DB에 들어있는 원본 비밀번호
		var pwd = f.pwd.value.trim(); //수정을 위해서 입력한 비밀번호
		
		if(ori_pwd != pwd){
			alert("비밀번호 불일치")
			return;
		}
		//비밀번호는 위에서 판별을 이미 했기 때문에 컨트롤러에서는 idx 하나만을
		//파라미터로 받으면 된다.
		f.action = "modify_form.do";
		f.method = "post";
		f.submit();
	}

</script>
</head>
<body>
	<div id="main_box" align="right">
		<h1>방명록 리스트</h1>
		<input type="button" value="글쓰기" onclick="location.href='insert_form.do'">
	</div>
		<c:forEach var="vo" items="${list}">
		<div class="visit_box">
			<div class="type_content"><pre>${vo.content}</pre>
				<c:if test="${vo.filename ne 'no_file' }">
					<img src="${pageContext.request.contextPath}/resources/upload/${vo.filename}" width="200">
				</c:if>
			</div>
			<div class="type_name">작성자 : ${vo.name}(${vo.ip})</div>
			<div class="type_regdate">작성일 : ${vo.regdate}</div>
			
			<div>
				<form>
					<input type="hidden" name="idx" value="${vo.idx }">
					<input type="hidden" name="ori_pwd" value="${vo.pwd}">
					비밀번호<input type="password" name="pwd">
					<input type="button" value="수정" onclick="modify(this.form);">
					<input type="button" value="삭제" onclick="del(this.form);">
				</form>
			
			</div>
		</div>
		
		</c:forEach>
</body>
</html>