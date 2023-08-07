function showContent(contentType) {
    console.log(contentType);

    const contentTypes = ['info', 'scrap', 'reservation', 'prev'];
    const contentContainers = {
        info: document.querySelector('.content-info'),
        scrap: document.querySelector('.content-scrap-container'),
        reservation: document.querySelector('.content-reservation-container'),
        prev: document.querySelector('.content-prev-container'),
    };

    contentTypes.forEach((type) => {
        const container = contentContainers[type];
        if (type === contentType) {
            container.style.display = 'block';
        } else {
            container.style.display = 'none';
        }
    });
}

btnEdit.addEventListener('click',function(){
    document.querySelector('#btnEdit').style.display = 'none';
    document.querySelector('#btnGoEdit').style.display = 'inline-block';
    document.querySelector('#btnGoDelete').style.display = 'inline-block';
    
    let inputs = document.getElementsByClassName('info-control');
    
    console.log(inputs);

    for(let i = 0; i < inputs.length; i++){
        inputs[i].readOnly = false;
        
    }
    
});

window.onload = function(){
	getResList();
}

function getResList(){
	let member_no = document.querySelector('#member_no').value;
	
	fetch('/mypage/student/reservation/'+ member_no)
	.then(response => response.json())
	.then(map => reservationView(map));
}

function reservationView(map){
	let list = map.student_resList;
	
	let reservation_container = document.querySelector('.content-reservation-container');
	reservation_container.innerHTML = '';
	
	list.forEach((list, index) => {
		
		reservation_container.innerHTML +=                                           
			 '<div class="content-reservation">                                       '
		   + '    <div class="content-reservation-title"><a>'+ list.class_title +'</a></div>'
		   + '    <div class="content-reservation-date">'+ list.reservation_date +' (월) '+ list.reservation_time +'</div>'
		   + '    <div class="content-reservation-cancel">                            '
		   + '        <button type="button" class="btn btn-primary">예약취소</button> '
		   + '    </div>                                                              '
		   + '</div>			                                                       '
	})     
	
	
}


