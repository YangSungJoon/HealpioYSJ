<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<link rel="stylesheet" href="/resources/css/read.css">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/gh/hiphop5782/score@latest/score.js"></script>
<script src="https://kit.fontawesome.com/0aadd0de21.js" crossorigin="anonymous"></script>
<script>
function go(url){
	location.href = url;
}

function fetchGet(url, callback){
	try{
		fetch(url)
		// 컨트롤러로부터 JSON 타입의 객체가 반환
		// 객체를 변수명 response에 받아 와서 json() 메소드를 호출
		// json() : JSON 형식의 문자열을 Promise 객체로 반환
		// Promise 객체는 then() 메소드를 사용하여 
		// 비동기 작업의 성공 또는 실패와 관련된 결과를 나타내는 대리자 역할을 수행
		.then(response => response.json())
		// 반환 받은 객체를 매개 변수로 받는 콜백 함수를 호출
		.then(map => callback(map));		
	} catch(e){
		console.log('fetchGet', e)
	}
}

function scrap(class_no){
	fetchGet('/class/scrap?class_no=' + class_no, getFullheart);
}

function cancelScrap(class_no){
	fetchGet('/class/cancelScrap?class_no=' + class_no, getEmptyheart);
}

function getFullheart(map){
	if(map.result=='success'){
		scrapDiv.innerHTML = `이 강의 찜하기 <i class="fa-solid fa-heart" style="color: #ff6666" onclick="cancelScrap('${classVO.class_no}')"></i>`;
	} else {
		alert(map.result);
	}
}

function getEmptyheart(map){
	if(map.result=='success'){
		scrapDiv.innerHTML = `이 강의 찜하기 <i class="fa-regular fa-heart" style="color: #ff6666" onclick="scrap('${classVO.class_no}')"></i>`;
	} else {
		alert(map.result);
	}
}

$(function(){	
    $('.score').score({
        starColor: "gold", //별 색상
        backgroundColor: "transparent", //배경 색상
        editable: true, //점수 변경 가능 여부
        integerOnly: true, //정수만 설정 가능 여부
        zeroAvailable:false,//0 설정 가능 여부
        send:{
            sendable:true,//전송 가능 여부
            name:"review_star",//전송 가능할 경우 전송될 이름
        },
        display: {
            showNumber: true, //설정된 숫자 표시 가능 여부
            placeLimit: 0, //소수점 자리수 표시 길이
            textColor:"black",//텍스트 색상
        },
        point: {
            max: 5,//최대 점수(data-max로 대체 가능)
            rate: 4,//실제 점수(data-rate로 대체 가능)
        }
    });
    

    $('.avgScore').score({
        editable:false,
        display:{
            showNumber:true,
            placeLimit:1
        }    
    });    
});

function showTeacher_content(class_no){
	class_contentBtn.classList.remove('form-menu-button-clicked');
	teacher_contentBtn.classList.add('form-menu-button-clicked');
	reviewBtn.classList.remove('form-menu-button-clicked');
	reservationBtn.classList.remove('form-menu-button-clicked');
	class_contentDiv.style.display = 'none';
	teacher_contentDiv.style.display = '';
	reviewDiv.style.display = 'none';
	reservationDiv.style.display = 'none';
}

function showReview(class_no){
	class_contentBtn.classList.remove('form-menu-button-clicked');
	teacher_contentBtn.classList.remove('form-menu-button-clicked');
	reviewBtn.classList.add('form-menu-button-clicked');
	reservationBtn.classList.remove('form-menu-button-clicked');
	class_contentDiv.style.display = 'none';
	teacher_contentDiv.style.display = 'none';
	reviewDiv.style.display = '';
	reservationDiv.style.display = 'none';
	fetchGet('/review/list?class_no=' + class_no, getReviewList);
}

function sorting(sortingCriteria, class_no){
	fetchGet('/review/sorting?sortingCriteria=' + sortingCriteria + '&class_no=' + class_no, getReviewList);
}

function getReviewList(map){
	reviewDiv.innerHTML = ``;
	reviewDiv.innerHTML += `<h5 style="display:inline"><b>리뷰 <span style="color: gold">★</span>` +  map.avgScore + `</b></h5> (` + map.reviewCount + `명 참여)`;
	console.log(map.sortingCriteria);
	let sortingCriteria1 = "";
	let sortingCriteria2 = "";
	let sortingCriteria3 = "";
	if("highest"===map.sortingCriteria){
		sortingCriteria2 = "selected";
	} else if("lowest"===map.sortingCriteria){
		sortingCriteria3 = "selected";
	} else{
		sortingCriteria1 = "selected";
	}
	let reviewSort = 
		`<select class="form-select form-select-sm" style="width:120px; float:right;" id="sortingCriteria" name="sortingCriteria" onchange="sorting(this.value, '${classVO.class_no}');">
		  <option value="latest"` + sortingCriteria1 + `>최신순</option>
		  <option value="highest"` + sortingCriteria2 + `>별점높은순</option>
		  <option value="lowest"` + sortingCriteria3 + `>별점낮은순</option>
		</select><br><br>`;
	reviewDiv.innerHTML += reviewSort;
	if(map.reviewList.length!=0){		
		map.reviewList.forEach(reviewVO => {
			let review = `<table style="width:100%"><tr><td style="width: 85%">`;
			review += reviewVO.nickname;
			review += ` <span style="color: gold"> ★</span>` + reviewVO.review_star;
			review += `<br>` + reviewVO.review_content + `</td>`;
			if(member_no.value==reviewVO.member_no){
				review += `<td>`;
				review += `<button type="button" class="btn btn-secondary btn-sm" style="float:right; margin:1px;" onclick="go('/review/delete?review_no=` + reviewVO.review_no + `')">삭제</button>`;
				review += `<button type="button" class="btn btn-danger btn-sm" style="float:right; margin:1px;" onclick="go('/review/edit?review_no=` + reviewVO.review_no + `')">수정</button>`;
				review += `</td>`;
			}
			review += `</tr></table><br><br>`;
			reviewDiv.innerHTML += review;
		})
		
		let pageblock = ``;
	} else {
		reviewDiv.innerHTML += `등록된 리뷰가 없습니다.<br><br><br>`;
	}
}

function showReservation(){
	class_contentBtn.classList.remove('form-menu-button-clicked');
	teacher_contentBtn.classList.remove('form-menu-button-clicked');
	reviewBtn.classList.remove('form-menu-button-clicked');
	reservationBtn.classList.add('form-menu-button-clicked');
	class_contentDiv.style.display = 'none';
	teacher_contentDiv.style.display = 'none';
	reviewDiv.style.display = 'none';
	reservationDiv.style.display = '';
}

function showClass_content(class_no){
	class_contentBtn.classList.add('form-menu-button-clicked');
	teacher_contentBtn.classList.remove('form-menu-button-clicked');
	reviewBtn.classList.remove('form-menu-button-clicked');
	reservationBtn.classList.remove('form-menu-button-clicked');
	class_contentDiv.style.display = '';
	teacher_contentDiv.style.display = 'none';
	reviewDiv.style.display = 'none';
	reservationDiv.style.display = 'none';
}
</script>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div id="container">
<div id="form">
<div id="form-intro">
	<div id="form-intro-img">
		<c:forEach items="${attachList}" var="attachVO">
		<img src='/resources/images/${attachVO.filepath}' alt='${classVO.class_title}' class="form-intro-img"><br>
		</c:forEach>
	</div>
	<div id="form-intro-content">
		<h2><b>${classVO.class_title}</b></h2>
		${classVO.nickname} | ${classVO.exercise_name}<br><br>
		<h6><i class="fa-solid fa-quote-left" style="color:#aaa"></i> <i>${classVO.class_introduce}</i> <i class="fa-solid fa-quote-right" style="color:#aaa"></i></h6><br>
		<hr>
		<div id="scrapDiv" style="display:inline;">
			이 강의 찜하기
			<c:if test="${scrapYN==0}">
			<i class="fa-regular fa-heart" style="color: #ff6666" onclick="scrap('${classVO.class_no}')"></i>
			</c:if>
			<c:if test="${scrapYN>0}">
			<i class="fa-solid fa-heart" style="color: #ff6666" onclick="cancelScrap('${classVO.class_no}')"></i>
			</c:if>			
		</div>
	　　문의하기
	<i class="fa-regular fa-envelope" style="color: #588ce0" onclick="window.open('/message/send?=${classVO.member_no}', ' ','width=500, height=570'); return false"></i><br><br><br>
	<div id="onlyWriter">
		<button type="button" class="btn btn-danger" onclick="go('/class/edit?class_no=${classVO.class_no}')">수정</button>
		<button type="button" class="btn btn-secondary" onclick="go('/class/delete?class_no=${classVO.class_no}')">삭제</button>
	</div>
	</div>
</div>

<div id="form-menu">
	<button type="button" class="form-menu-button form-menu-button-clicked" id="class_contentBtn" onclick="showClass_content('${classVO.class_no}')">강의 소개</button>
	<button type="button" class="form-menu-button" id="teacher_contentBtn" onclick="showTeacher_content('${classVO.class_no}')">강사 소개</button>
	<button type="button" class="form-menu-button" id="reviewBtn" onclick="showReview('${classVO.class_no}')">리뷰</button>
	<button type="button" class="form-menu-button" id="reservationBtn" onclick="showReservation()">예약</button>
</div>

<!-- 강의 소개 -->
<div id="class_contentDiv" style="white-space: pre-line;">
	<h5 style="margin: 0px"><b>강의 내용</b></h5>
	${classVO.class_content}<br><br><br>
	<h5 style="margin: 0px"><b>최대 수강 인원</b></h5>
	${classVO.class_maxcount}명<br><br><br>
	<h5 style="margin: 0px"><b>수강료</b></h5>
	${classVO.class_price}
</div>

<!-- 강사 소개 -->
<div id="teacher_contentDiv" style="display:none; white-space: pre-line;">
	<h5 style="margin: 0px"><b>강사 소개</b></h5>
	${classVO.teacher_content}
</div>

<!-- 리뷰 -->
<div id="reviewDiv" style="display:none;">
	<!-- 리뷰 페이지 유지시 필요 -->
	<input type="text" id="page" name="page">

</div>
<form action="/review/write">
	<!-- 리뷰쓰기(삭제 예정) -->
	<button type="submit" id="reviewWriteBtn">리뷰쓰기</button>
	<!-- 리뷰 작성시 필요 -->	
	<input type="text" name="class_no" id="class_no" value="${classVO.class_no}">
	<!-- 리뷰 작성,수정,삭제시 필요 -->	
	<input type="text" name="member_no" id="member_no" value="M000002">
</form>

<div id="reservationDiv" style="display:none">
<nav>
  <ul class="pagination pagination-sm justify-content-center">
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
      </a>
    </li>
    <li class="page-item"><a class="page-link" style="color: black;" href="#">1</a></li>
    <li class="page-item"><a class="page-link" style="color: black;" href="#">2</a></li>
    <li class="page-item"><a class="page-link" style="color: black;" href="#">3</a></li>
    <li class="page-item">
      <a class="page-link" href="#" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
  </ul>
</nav>
</div>
</div>
</div>
<%@ include file="../common/footer.jsp" %>
</body>
</html>