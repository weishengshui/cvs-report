<%@ page contentType="text/html;charset=gb2312" %>     	
	<form name="user_login" action="memberprizesave.jsp" method="post">
			<input name='_tb_token_' type='hidden' value='ef33193831531#9270831165343064'>
							<p class="WarningMsg">录入会员获得奖品记录：</p>
						<label for="Username">交易号:
			<input id="posid" name="posid" type="text" size="18" value="" />
			</label><br/>

						<label for="Username">会员标识（手机号码或卡号):
			<input id="mp" name="mp" type="text" size="18" value="" />
			</label><br/>
						<label for="Username">消费金额:
			<input id="money" name="money" type="text" size="18" value="" />
			</label>
<br/>
						<label for="Username">姓名:
			<input id="name" name="name" type="text" size="18" value="" />
			</label>


<br/>
						<label for="Username">领取地点:
			<input id="address" name="address" type="text" size="18" value="" />
			</label>

<br/>
						<label for="Username">奖品:
			<input id="prize" name="prize" type="text" size="18" value="" />
			</label>

<br/>
						<label for="Username">负责人:
			<input id="ren" name="ren" type="text" size="18" value="" />
			</label>

<br/>
						<label for="Username">备注:
			<input id="remark" name="remark" type="text" size="18" value="" />
			</label>

			<div class="Submit">
				<input type="submit" name="Submit" value="下一步" />
			</div>
			<input type="hidden" NAME="event_submit_do_request_forgot_passwd" VALUE="anything">
			
    		</form>
