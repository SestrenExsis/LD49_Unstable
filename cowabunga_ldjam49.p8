pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--up ❎=uppercut sprite2
--❎=punch sprite3
--down ❎=kick sprite4,5
--up🅾️ =chargeram spt 6-17,18,19
--🅾️ =jump sprite4-7
--🅾️-❎ =slamdown spt22
--down🅾️ =kickflip
--story:there's an unstable
--crime syndicate that will
--eventually devour this city in
--crime, and everyone lost hope
--but one hero did not but who
--he is... stays a mystery
--until he now reveals himself 
--heroically by slaying this
--unholy dragon who could've
--left the city aflame. but will
--he be able to destroy the
--syndicate? and viewers hardly
--saw him but only made out that
--killed it and not his identity.

--win:survive to last wave 

--track1:unusuality_titlescreen
--track2:utter chaos_intro 
--pattern0-1-2:credits
--track7:killing crime_wave1-3
--track8:no stopping_wave4-6
--track9:moo free_bosswave7
--track10:cow-abunga_wave8-13
--track11:unstoppable_boss14 
--track12:thunder hits_wave18-20
--track13:the finally_finalwave
-->8
-- cowabunga
-- by sestrenexsis
-- & equalenergy
-- https://github.com/sestrenexsis/ld49_unstable

--[[
 2d platformer in one spot
 defend city from enemy waves
 defeat 21 waves to win
--]]

_me="sestrenexsis"
_cart="ldjam49"
--cartdata(_me.."_".._cart.."_1")
--_version=1
_cowup=true -- conscious?
_minhp=200
_maxhp=1000
_cowhp=_maxhp
_cowx=0
_cowy=0
_cowvy=0 -- y velocity
_coww=0 -- frames spent walking
_cowf="" -- direction facing
_grav=0.5
_jump=-4
_ceil=0
_flor=92
_costs={}
_costs["fire"]=1
_costs["jump"]=30
_costs["hurt"]=90
_atks={} -- attacks
_foes={} -- enemies

function _init()
	initarena()
end

function _update()
	updatefn()
end

function _draw()
	drawfn()
end

function initarena()
	_cowhp=_minhp
	_cowup=true
	_cowx=60
	_cowy=_flor
	_coww=0
	_cowf="rt"
	initfn=initarena
	updatefn=updatearena
	drawfn=drawarena
end

function dothecowthings()
	local mov=false
	local tx=_cowx
	local ty=_cowy
	if btn(➡️) then
		mov=true
		tx+=1
		_cowf="rt"
	elseif btn(⬅️) then
		mov=true
		tx-=1
		_cowf="lf"
	end
	if btnp(❎) then
		local vx=2
		local vy=0
		if _cowf=="lf" then
			vx*=-1
		end
		add(_atks,
			{_cowx,_cowy+2,vx,vy,30}
		)
		_cowhp-=_costs["fire"] or 0
	end
	if btnp(🅾️) then
		_cowvy=_jump
		_cowhp-=_costs["jump"] or 0
	end
	if mov then
		_cowx=tx
		_cowy=ty
		_coww+=1
	else
		_coww=0
	end
end

function updatearena()
	if _cowup then
		dothecowthings()
	end
	for a in all(_atks) do
		local vx=a[3]
		local vy=a[4]
		a[1]+=vx
		a[2]+=vy
		a[5]-=1
		if a[5]<1 then
			del(_atks,a)
		end
	end
	-- apply jumping and gravity
	_cowy=mid(
		_ceil,
		_cowy+_cowvy,
		_flor
	)
	if _cowy==_flor then
		_cowvy=0
	end
	_cowvy+=_grav
	-- update health
	if _cowhp<1 then
		_cowup=false
	end
	_cowhp=min(_maxhp,_cowhp+1)
	if _cowhp>=_minhp then
		_cowup=true
	end
	-- spawn new enemies
	if rnd()<0.01 then
		local x=rnd({0,128})
		local y=rnd({4,26,48,70,92})
		add(_foes,
			{x,y,16,16,1}
		)
	end
	-- update enemies
	for f in all(_foes) do
		local fx1=f[1]
		local fy1=f[2]
		local fx2=f[1]+f[3]
		local fy2=f[2]+f[4]
		for a in all(_atks) do
			local ax1=a[1]
			local ay1=a[2]
			local ax2=a[1]+8
			local ay2=a[2]+8
			if not (
				fx1>ax2 or
				fx2<ax1 or
				fy1>ay2 or
				fy2<ay1
			) then
				f[5]-=1
			end
		end
		if f[1]<64 then
			f[1]+=1
		elseif f[1]>64 then
			f[1]-=1
		end
		if f[1]<_flor then
			f[2]+=1
		end
		if f[5]<1 then
			del(_foes,f)
		end
	end
end

function drawarena()
	palt(0,false)
	palt(4,false)
	cls(4)
	palt(4,true)
	-- draw cow
	local f1=1
	local f2=17
	local x1=_cowx
	local x2=_cowx
	local y1=_cowy
	local y2=_cowy+8
	local flp=false
	if _cowf=="lf" then
		flp=true
	end
	if not _cowup then
		f1=16
		f2=32
		x1=_cowx-4
		x2=_cowx+4
		if flp then
			x1+=8
			x2-=8
		end
		y1=_cowy+8
		y2=_cowy+8
	elseif _coww>0 then
		f2+=flr((15+_coww/15)%4)
	end
	spr(f1,x1,y1,1,1,flp)
	spr(f2,x2,y2,1,1,flp)
	-- draw enemies
	for f in all(_foes) do
		local aflp=false
		if f[1]>64 then
			aflp=true
		end
		spr(10,f[1],f[2],2,2,aflp)
	end
	-- draw cow's attacks
	for a in all(_atks) do
		local aflp=false
		if a[3]<0 then
			aflp=true
		end
		spr(3,a[1],a[2],1,1,aflp)
	end
	print(_cowhp,1,1,7)
end
__gfx__
4444444440044004400000444444444407efe10407efe10440044004400400044000000440000044400000044400000044444444444444444444444444444444
444444440150015040888e044444004407efe70407efe7040150015001505104018051040058ee04055555500055555044400004444000044444440000444444
447447444077770040888ee00000880407efe50401efe504051775100517770005887700078576e005666750115666504408aa0000008aa04444400a00000444
44477444081181104065588007788ee0077e7710017e7704401282804081818040818180067567e00567775181577650440a8aa01108a8a0444000aa810a0004
444774440881881007768860771885e00177711000777760408828204088182040881820055555500567775818576550408a88a1221a88a044400aa88288aa04
4474474408877550011766007118858007107710407106600887717000887550007775500d2d22d04056775581576504408aa88a12588aa04440aa88aa8aaa04
444444440817511071777004777888800104000040110110071e1550078715100777151002d2dd204056777555775504408aaa8a52588aa04440aa88ac888a04
4444444407ee70047700004400000000004444444400400007ef700407ee700407eee0040858599044056777576650444408aa8aa55a8a044440aa88c7ca8a04
400000040efee10440efee1040efee1040efee10444444440efee104444444440858858005555550440555555555504444408a8aaaaaaa0444408a88c7caaa04
050885100effe70440effe7040effe7040effe70444444440effe704444444440555555005888850405522882822550444408aaaaaa7780444408aaaaca77804
017115170effe70440effe7040effe7040effe70444444440effe7044444444408555580085555800565522222255650444400aa777a7a04444400aa777a7a04
4078875e07ee7104407ee710407ee710407ee7104444444407ee770044444444000000000000000005675111111576504440888aa7aa80444440888aa7aa8044
407117ef01771104401771104017711040777110444444440177711044444444088a9880088a988005775899a885775044408aaaaaaa804444408aaaaaaa8044
0571881e077077040777177001770770071707704444444401707710444444444089a8044089a8040577588a9805775044408aaa088a804444408aaa088a8044
0108888001101104011011040170111001107110444444440000000444444444440800444408804405555088800555504440000000a880444440000000a88044
40400004000000044004004440000000400000044444444444444444444444444400044444000044000004000440000044440000440004444444000044000444
44400044000044400004444444444444444444444400000000044444444400000040000444404444444444444444444444444444000000004444444444444444
00001104015100001504444444440000000444444066666677044044440000221200022044050444000000004000000444444444cccccccc4444444444444444
17771704000777775000044444400888eee00444406777777700050444022200515022104058504405666660405cdd04444444446ddd66d64444444444444444
eee7770440717717088880044408858888eee04440677111170505500022288877172150058585040598689040c67d0444444444777777774444444444444444
effe7004407177108878880440885885558eee0440677177170818100228858188777500095858500589698040c76c0444444444777777774444444444444444
ffee770440777008877888044088888885888e0040677111170077700288588118887720059959500566666040d67c0444444444d66ddd6d4444444444444444
eee7110440660888877880440888888885588ee04077717710e876100288827818818720055555500567676040ddc50444444444cccccccc4444444444444444
0000000440608888888004440858888888588e80407771111707f704022222788811882000000000000000004000000444444444000000004444444444444444
4444444440088888880770440855588888888880407771771707f8e00ee727777888822044444444444444444444444444444444444444444444444444444444
44444444008777788077770440858888888888004077711117077ee00e8777eee777772044444444444444444444444444444444444444444444444444444444
4444444408887788077777044088888888888804407771111707070008877effe667112044444444444444444444444444444444444444444444444444444444
4444444408888800077777704407667676777044400000000010110402227effe771552044444444444444444444444444444444444444444444444444444444
444444440858000807775570440ffff888860444444444444400000440227eee7778e20044444444444444444400044444444444444444444444444444444444
4444444440885588077775704440fffffff604444444444444444444440277777728820444444444444444440088e00444444444444444444444444444444444
44444444440588800007777044440ff6f66004444444444444444444440222222222204444444444444444440555550444444444444444444444444444444444
44444444444000044400000044440000000044444444444444444444440000000000044444444444444444440000000444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444407777044444444444444444407777044444444444444444444444444444444444444444
44444444444444444444444444444444440000044444444444444444007711044444444444444444401177004444444444444444444444444444444444444444
44444444444444444444444000444444400155504444444444444444077117044444444444444444407117704444444444444444444444444444444444444444
44444444444444444444440515000000001111550444444444444444077777044444444444444444407777704444444444444444444444444444444444444444
44444444444444444444405115007777751151504444444444444444077777044444444444444444407777704444444444444444444444444444444444444444
44444444444444444444440051177777775150044444444444444444077777044444444444444444407777704444444444444444444444444444444444444444
44444444444444444444444401777777777504444444444444444444011111044444444444444444401111104444444444444444444444444444444444444444
4444444444444444444444440588c88888c704444444444444444444011117044444444444444444407111104444444444444444444444444444444444444444
444444444444444444444440088cc888ccc800444444444444444444061117044444444444444444407111604444444444444444444444444444444444444444
4444444444444444444444400788cc888c8880044444444444444444066117044444444444444444407116604444444444444444444444444444444444444444
44444444444444444444444007777777777880044444444444444444000000044444444444444444400000004444444444444444444444444444444444444444
44444444444444444444440077777777777880444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440117777777777880444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440511177667771770444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440115516677771170444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444011166677ee7117704444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444444444000677eeffe777770444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444444444000777efffe707770444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444444444077777effffe07110444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444001170efffffe07170444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444001170efffffe07770044444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440077700efffffe07888804444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440ee88077effffe88858804444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444440e855877eeffee7855ee04444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444444408858877eeeee77088ee04444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444088880000000000000044444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444400000444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
888888888888888888888888888888888888888888888888888888888888888888888888888888888882282288882288228882228228888888ff888888228888
888882888888888ff8ff8ff88888888888888888888888888888888888888888888888888888888888228882288822222288822282288888ff8f888888222888
88888288828888888888888888888888888888888888888888888888888888888888888888888888882288822888282282888222888888ff888f888888288888
888882888282888ff8ff8ff888888888888888888888888888888888888888888888888888888888882288822888222222888888222888ff888f888822288888
8888828282828888888888888888888888888888888888888888888888888888888888888888888888228882288882222888822822288888ff8f888222288888
888882828282888ff8ff8ff8888888888888888888888888888888888888888888888888888888888882282288888288288882282228888888ff888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555000000000000555555555555555555555555555555555500000000000055000000000000555
555555e555566656665555e555555555555555556656665665555066006660000555555555555555565555665566566655506660666000055066606660000555
55555ee555565655565555ee55555555555555565556565656555006006060000555555555555555565556565656565655506060606000055060606060000555
5555eee555565656665555eee5555555555555566656665656555006006060000555555555555555565556565656566655506060606000055060606060000555
55555ee555565656555555ee55555555555555555656555656555006006060000555555555555555565556565656565555506060606000055060606060000555
555555e555566656665555e555555555555555566556555666555066606660000555555555555555566656655665565555506660666000055066606660000555
55555555555555555555555555555555555555555555555555555000000000000555555555555555555555555555555555500000000000055000000000000555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555555555666665777775666665666665555555666666665666666665666666665666666665666666665666666665666666665ffffffff555555555
555556655665666555655665755575655565656565555555666776665666667665666666775667777765666677765667666665667666765fff77fff555dd5555
555565656555565555665665777575666565656565555555667667665666776765666677675667666765666676765676766665767676765ff7777ff55d55d555
555565656555565555665665755575665565655565555555676666765677666765667766675667666765666676765766676765777777775f77ff77f55d55d555
55556565655556555566566575777566656566656555555576666667576666667577666667577766677577777677576667767567676767577ffff77555dd5555
555566555665565555655565755575655565666565555555666666665666666665666666665666666665666666665666666665676666675ffffffff555555555
55555555555555555566666577777566666566666555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555555555005005005005005dd500566555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555565655665655555005005005005005dd5665665555555777777775dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd555555555
555565656565655555005005005005005775665665555555777777775d55ddddd5dd5dd5dd5ddd55ddd5ddddd5dd5dd5ddddd5dddddddd5dddddddd555555555
555565656565655555005005005005665775665665555555777777775d555dddd5d55d55dd5dddddddd5dddd55dd5dd55dddd55d5d5d5d5d55dd55d555555555
555566656565655555005005005665665775665665555555777557775dddd555d5dd55d55d5d5d55d5d5ddd555dd5dd555ddd55d5d5d5d5d55dd55d555555555
555556556655666555005005665665665775665665555555777777775ddddd55d5dd5dd5dd5d5d55d5d5dd5555dd5dd5555dd5dddddddd5dddddddd555555555
555555555555555555005665665665665775665665555555777777775dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
5550000000000000000000000000000055000000000000000000000000000005501111111111111111111111aaaaa05500000000000000000000000000000555
55507770000066000eee00ccc00dd0005507770000066000eee00ccc00ddd005507771111166111eee11ccc1aaaaa05507770000066000eee00ccc0000000555
5550707000000600000e00c00000d000550700000000600000e00c000000d00550717111111611111e11c111aaaaa0550700000000600000e00c000000000555
55507770000006000eee00ccc000d0005507700000006000eee00ccc000dd005507711111116111eee11ccc1aaaaa05507700000006000eee00ccc0000000555
55507070000006000e000000c000d0005507000000006000e000000c0000d005507171111116111e111111c1aaaaa05507000000006000e000000c0000000555
55507070000066600eee00ccc00ddd005507770000066600eee00ccc00ddd005507771111166611eee11ccc1aadaa05507000000066600eee00ccc000d000555
5550000000000000000000000000000055000000000000000000000000000005501111111111111111111111aaaaa05500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507700000066000eee00ccc00ddd005507770000066000eee00ccc00d0d005507770000066000eee00ccc00000005507770000066000eee00ccc0000000555
5550707000000600000e00c000000d00550700000000600000e00c0000d0d00550700000000600000e00c000000000550707000000600000e00c000000000555
55507070000006000eee00ccc000dd005507700000006000eee00ccc00ddd005507700000006000eee00ccc00000005507770000006000eee00ccc0000000555
55507070000006000e000000c0000d005507000000006000e000000c0000d005507000000006000e000000c00000005507070000006000e000000c0000000555
55507770000066600eee00ccc00ddd005507000000066600eee00ccc0000d005507770000066600eee00ccc000d0005507070000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00d0d005507770000066000eee00ccc00ddd005507700000066000eee00ccc00000005500770000066000eee00ccc0000000555
5550700000000600000e00c0000d0d00550707000000600000e00c000000d00550707000000600000e00c000000000550700000000600000e00c000000000555
55507700000006000eee00ccc00ddd005507770000006000eee00ccc00ddd005507070000006000eee00ccc00000005507000000006000eee00ccc0000000555
55507000000006000e000000c0000d005507070000006000e000000c00d00005507070000006000e000000c00000005507000000006000e000000c0000000555
55507000000066600eee00ccc0000d005507070000066600eee00ccc00ddd005507770000066600eee00ccc000d0005500770000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00ddd005500770000066000eee00ccc00ddd005507770000066000eee00ccc00000005507700000066000eee00ccc0000000555
5550707000000600000e00c000000d00550700000000600000e00c000000d00550707000000600000e00c000000000550707000000600000e00c000000000555
55507770000006000eee00ccc000dd005507000000006000eee00ccc000dd005507770000006000eee00ccc00000005507070000006000eee00ccc0000000555
55507070000006000e000000c0000d005507000000006000e000000c0000d005507070000006000e000000c00000005507070000006000e000000c0000000555
55507070000066600eee00ccc00ddd005500770000066600eee00ccc00ddd005507070000066600eee00ccc000d0005507770000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066600eee00ccc00ddd005507700000066000eee00ccc00d0d005507770000066000eee00ccc00000005507700000066000eee00ccc0000000555
5550700000000060000e00c000000d00550707000000600000e00c0000d0d00550700000000600000e00c000000000550707000000600000e00c000000000555
55507700000066600eee00ccc00ddd005507070000006000eee00ccc00ddd005507700000006000eee00ccc00000005507070000006000eee00ccc0000000555
55507000000060000e000000c00d00005507070000006000e000000c0000d005507000000006000e000000c00000005507070000006000e000000c0000000555
55507000000066600eee00ccc00ddd005507770000066600eee00ccc0000d005507000000066600eee00ccc000d0005507770000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00d0d005507770000066000eee00ccc00ddd005507770000066000eee00ccc00000005507770000066000eee00ccc0000000555
5550707000000600000e00c0000d0d00550700000000600000e00c000000d00550707000000600000e00c000000000550700000000600000e00c000000000555
55507770000006000eee00ccc00ddd005507700000006000eee00ccc00ddd005507700000006000eee00ccc00000005507700000006000eee00ccc0000000555
55507070000006000e000000c0000d005507000000006000e000000c00d00005507070000006000e000000c00000005507000000006000e000000c0000000555
55507070000066600eee00ccc0000d005507770000066600eee00ccc00ddd005507770000066600eee00ccc000d0005507770000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00dd0005507770000066000eee00ccc00ddd005507700000066000eee00ccc00000005507770000066000eee00ccc0000000555
5550707000000600000e00c00000d000550707000000600000e00c000000d00550707000000600000e00c000000000550707000000600000e00c000000000555
55507770000006000eee00ccc000d0005507700000006000eee00ccc000dd005507070000006000eee00ccc00000005507770000006000eee00ccc0000000555
55507070000006000e000000c000d0005507070000006000e000000c0000d005507070000006000e000000c00000005507070000006000e000000c0000000555
55507070000066600eee00ccc00ddd005507770000066600eee00ccc00ddd005507770000066600eee00ccc000d0005507070000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00ddd005507770000066000eee00ccc00d0d005507770000066000eee00ccc00000005507770000066600eee00ccc0000000555
5550707000000600000e00c000000d00550700000000600000e00c0000d0d00550700000000600000e00c000000000550700000000060000e00c000000000555
55507700000006000eee00ccc00ddd005507700000006000eee00ccc00ddd005507700000006000eee00ccc00000005507700000066600eee00ccc0000000555
55507070000006000e000000c00d00005507000000006000e000000c0000d005507000000006000e000000c00000005507000000060000e000000c0000000555
55507770000066600eee00ccc00ddd005507770000066600eee00ccc0000d005507770000066600eee00ccc000d0005507770000066600eee00ccc000d000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555551555555555555555555555555555555555555555555555555555
5555dd555dd5ddd5ddd555555ddd5d5d5ddd5ddd555555dd55ddd5ddd5d5d5dd55ddd5555dd171dd5d5d5ddd5ddd5ddd5555dd55ddd5ddd5ddd5ddd5dd555555
5555d5d5d5d55d5555d555555d5d5d5d555d555d555555d5d5d5555d55d5d5d5d5d555555d5177155d5d5d555d5d5d5d5555d5d5d5d5ddd5d5d5d555d5d55555
5555d5d5d5d55d555d5555555dd55d5d55d555d5555555d5d5dd555d55d5d5d5d5dd55555dd177715d5d5dd55dd55dd55555d5d5ddd5d5d5ddd5dd55d5d55555
5555d5d5d5d55d55d55555555d5d5d5d5d555d55555555d5d5d5555d55d5d5d5d5d555555d5177771ddd5d555d5d5d5d5555d5d5d5d5d5d5d555d555d5d55555
5555d5d5dd55ddd5ddd555555ddd55dd5ddd5ddd555555ddd5ddd55d555dd5d5d5ddd5555d51771155d55ddd5d5d5ddd5555ddd5d5d5d5d5d555ddd5d5d55555
55555555555555555555555555555555555555555555555555555555555555555555555555551171555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55551111111111111115555551111111111111115555551111111111111111111111155551111111111111111111111155551111111111111111111111155555
555511111111eeeeee155555511111111eeeeee1555555111111111111111fffffff15555111111111111111fffffff155551dddddd111111111111111155555
555511111111eeeeee155555511111111eeeeee1555555111111111111111fffffff15555111111111111111fffffff155551dddddd111111111111111155555
555511111111eeeeee155555511111111eeeeee1555555111111111111111fffffff15555111111111111111fffffff155551dddddd111111111111111155555
55551111111111111115555551111111111111115555551111111111111111111111155551111111111111111111111155551111111111111111111111155555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
3f3f3f3f3f3f3f3f3f3f3f3f494a3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f0a0b595a3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f073f083f0102033f3f1a1b3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f053f163f11424344453f3f0c0d3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f063f3f3f3f52535455093f1c1d3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f113f10203f62636465193f0e0f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f727374753f3f1e1f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f595a57583f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
1402000009050090500a0500c0500c050106550b0510805413653060521465100001156531565215650156501565015650100500c0520805306054060510c6530c6540a0500c620000201102014000170101a000
14200c2014736076421225314726102640d334074270d2631264210356177640b2211763709342114530963617224073671144211623172161135404731114421766709123103360d754004420e617032230d364
421e0020155650e77411135150451d5651517515765170451017511564157240c1350e07410745177641051517124100350e7741514511564171750e7241006511074150640c0440e5740e06410735150751c044
2310002024755277522675428752277552575427752287552775225754287552575224754277552b752247542b75224755297542a752247552475427752297552a754247522775524752297542a7552475227754
4710002024725277422672428722277252572427722287252772225724287252572224724277552b722247242b72224725297242a722247252472427752297252a724247222772524722297342a7252472227724
05110e0124725277222672428722277252572427722287252772225724287252572224724277252b722247242b72224725297242a722247252472427722297252a724247222772524722297242a7252472227724
420e090124705277022670428702277052570427702287052770225724287252572224724277252b722247242b72224725297242a722247252472427722297252a724247222772524722297242a7252472227724
9e0c00200005500152000540c15518053001520c05418051000550c0560005318052001530c152000541815500051181520c0540015318052001510c055181540005200155180540c1530c0550c1520c05418151
3c1400200a572005220a562025320a532015320853208532085320253209542005120953200542095620352206532035720654208562015220853201542085720156208522015320a56208542005220857200562
6e1100200a17209172091720a1720a1720a1720517206172041720717206172081720617206172091720417206172061720a17206172061720a17207172081720a17208172081720a172071720a1720f17213172
9014002006545133120022611353035340357210343035250e353073320c3430731407327093520833307344093650535200326043330536209345053570831303526035340c3650224201257103230453418376
000c002018155101530a15408155071530715408155041530015402155061530b155151530815408155091530915409155091530a1540c1551c1531c154071550f15316154181550815312154051550715316154
0010000008611076140e6530e641066110661106611046110c6342a6330661106611026110261106611056110561205613056550d65214673056751f6522a655056133b672056150661306612066150561304614
bc1000200e15423653151571115218153171541e653102531525211257182560e2531025717254153562165321653173571735629654173521035329657113530e53218453174562465315457115521855324653
39040000166211d62122621256212663125631206311f624326243a65400002000040000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
170c00000e62110631116410000011630116501163011650000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800001661000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000e6001065011650000200000017620000001d620000202262025620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 03050444
00 03044506
02 04060503

