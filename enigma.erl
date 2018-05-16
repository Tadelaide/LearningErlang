%% @author wlt
%% @doc @todo Add description to pingpong.

- module (enigma).
- author ("Letian Wang").
%% ====================================================================
%% API functions
%% ====================================================================

- export ([ setup/5,crypt/2,kill/1,setReflector/1,machine/1,reflectorA/1,reflectorB/1,reflectorC/1,reflectorThinB/1,reflectorThinC/1,setInPlugboard/1,setOutPlugboard/1,inPlugboard/2,outPlugboard/2,keyboardIn/2,lookup/2,lookupback/2,setRotor/3,sequenceRotor/4,ringSetting/4,initialSetting/3,setRurrentRotor/2]).



setup (ReflectorName, RotorSequence, RingSetting, PlugboardPairs, InitialSetting ) ->
    % Enigma_PID = spawn ( enigma , machine , [ReflectorName, RotorSequence, RingSetting, PlugboardPairs, InitialSetting ]),
    setInPlugboard(PlugboardPairs),
    setRotor(RotorSequence,RingSetting,InitialSetting),
    setReflector(ReflectorName),
    setOutPlugboard(PlugboardPairs),
    io : format ("setup finished~n" ,[]).


%This one make sure if input is a string, it can input to the machine one character by one character
crypt (Enigma_PID, Text) ->
    keyboardIn(Enigma_PID, Text).

%kill method will receive a Enigma_PID to stop the all processes
kill (Enigma_PID) ->
    exit(Enigma_PID,kill).

machine(0) ->
    io : format ("The machine it stopped" ,[]).
%% ====================================================================
%% Keyboard
%% ====================================================================
%keyboard process give the origin input to Enigma,
%This is designed for a string input
keyboardIn(Enigma_PID, [CharacterA|CharacterB]) ->
    if 
        CharacterB == [] ->
            io : format ("The whole input has finished. \n");
        true ->
            spawn (enigma, machine, [CharacterA, Enigma_PID]),
            crypt(Enigma_PID,CharacterB)
    end.


keyboardOut(Enigma_PID, CharacterLamp) ->
    io : format ("The output if ~p. \n",[CharacterLamp]).

%% ====================================================================
%% Keyboard
%% ====================================================================
%% ====================================================================
%% Reflector
%% ====================================================================
%setReflector method setup the Reflector 
setReflector(ReflectorName) ->
    if
        ReflectorName == "A" ->
            Reflector_PID = spawn(enigma, reflectorA,[]);
        ReflectorName == "B"->
            Reflector_PID = spawn(enigma, reflectorB,[]);
        ReflectorName == "C"->
            Reflector_PID = spawn(enigma, reflectorC,[]);
        ReflectorName == "ThinB"->
            Reflector_PID = spawn(enigma, reflectorThinB,[]);
        ReflectorName == "ThinC"->
            Reflector_PID = spawn(enigma, reflectorThinC,[]);
        true ->
            io : format ("The name of reflector is wrong" ,[])
            % kill (Enigma_PID)
    end.

reflectorA(InReflectorCharacter) ->
        ReflectorList = [{$A,$E}, {$B,$J}, {$C,$M}, {$D,$Z}, {$F,$L}, {$G,$Y}, {$H,$X}, {$I,$V}, {$K,$W}, {$N,$R}, {$O,$Q}, {$P,$U}, {$S,$T}],
        lookup(ReflectorList,InReflectorCharacter).

reflectorB(InReflectorCharacter) ->
        ReflectorList =      [{$A,$Y}, {$B,$R}, {$C,$U}, {$D,$H}, {$E,$Q}, {$F,$S}, {$G,$L}, {$I,$P}, {$J,$X}, {$K,$N}, {$M,$O}, {$T,$Z}, {$V,$W}],
        lookup(ReflectorList,InReflectorCharacter).

reflectorC(InReflectorCharacter) ->
        ReflectorList = [{$A,$F}, {$B,$V}, {$C,$P}, {$D,$J}, {$E,$I}, {$G,$O}, {$H,$Y}, {$K,$R}, {$L,$Z}, {$M,$X}, {$N,$W}, {$T,$Q}, {$S,$U}],
        lookup(ReflectorList,InReflectorCharacter).

reflectorThinB(InReflectorCharacter) ->
        ReflectorList = [{$A,$E}, {$B,$N}, {$C,$K}, {$D,$Q}, {$F,$U}, {$G,$Y}, {$H,$W}, {$I,$J}, {$L,$O}, {$M,$P}, {$R,$X}, {$S,$Z}, {$T,$V}],
        lookup(ReflectorList,InReflectorCharacter).

reflectorThinC(InReflectorCharacter) ->
        ReflectorList = [{$A,$R}, {$B,$D}, {$C,$O}, {$E,$J}, {$F,$N}, {$G,$T}, {$H,$K}, {$I,$V}, {$L,$M}, {$P,$W}, {$Q,$Z}, {$S,$X}, {$U,$Y}],
        lookup(ReflectorList,InReflectorCharacter).
%% ====================================================================
%% Reflector
%% ====================================================================
%% ====================================================================
%% Plugboard
%% ====================================================================
%setup the Plugboard part, and make it give a PID to others.
setInPlugboard(PlugboardPairs) ->
    InPlugboard_PID = spawn(enigma, inPlugboard,[]).
setOutPlugboard(PlugboardPairs) ->
    OutPlugboard_PID = spawn(enigma, outPlugboard,[]).
inPlugboard(PlugboardPairs,Character) ->
    lookup(PlugboardPairs,Character).
outPlugboard(PlugboardPairs,Character) ->
    lookupback(PlugboardPairs,Character).
%% ====================================================================
%% Plugboard
%% ====================================================================
%% ====================================================================
%% Function part
%% ====================================================================
%this is a method for lookup the character 
lookup([{InCharacter,OutCharacter}|Rest],Character) ->
    if 
        InCharacter == Character ->
            io : format("~p ~n",[OutCharacter]);
        Rest == [] ->
            io : format("~p back the origin word~n .",[Character]);
        true ->
            lookup(Rest,Character)
    end.
%this one function make sure when the character come back, it can find a right word
lookupback([{InCharacter,OutCharacter}|Rest],Character) ->
    if 
        OutCharacter == Character ->
            io : format("~p ~n",[InCharacter]);
        Rest == [] ->
            io : format("~p back the origin word~n .",[Character]);
        true ->
            lookup(Rest,Character)
    end.
%% ====================================================================
%% Funcation part
%% ====================================================================
%% ====================================================================
%% Rotor
%% ====================================================================
%This part is quite difficulty to design, it needs to divide everything into Hd and Rl.
setRotor(RotorSequence,RingSetting,InitialSetting) ->
    RotorCount = 1,
    sequenceRotor(RotorSequence,RotorCount,RingSetting,InitialSetting).

%this function choose the Rotor following the sequence
sequenceRotor([HdSeq|RlSeq],RotorCount,[HdSet|RlSet],[HdInit|RlInit]) ->
    RotorI = [{$A,$E},{$B,$K},{$C,$M},{$D,$F},{$E,$L},{$F,$G},{$G,$D},{$H,$Q},{$I,$V},{$J,$Z},{$K,$N},{$L,$T},{$M,$O},{$N,$W},{$O,$Y},{$P,$H},{$Q,$X},{$R,$U},{$S,$S},{$T,$P},{$U,$A},{$V,$I},{$W,$B},{$X,$R},{$Y,$C},{$Z,$J}],
    RotorII = [{$A,$A},{$B,$J},{$C,$D},{$D,$K},{$E,$S},{$F,$I},{$G,$R},{$H,$U},{$I,$X},{$J,$B},{$K,$L},{$L,$H},{$M,$W},{$N,$T},{$O,$M},{$P,$C},{$Q,$Q},{$R,$G},{$S,$Z},{$T,$N},{$U,$P},{$V,$Y},{$W,$F},{$X,$V},{$Y,$O},{$Z,$E}],
    RotorIII = [{$A,$B},{$B,$D},{$C,$F},{$D,$H},{$E,$J},{$F,$L},{$G,$C},{$H,$P},{$I,$R},{$J,$T},{$K,$X},{$L,$V},{$M,$Z},{$N,$N},{$O,$Y},{$P,$E},{$Q,$I},{$R,$W},{$S,$G},{$T,$A},{$U,$K},{$V,$M},{$W,$U},{$X,$S},{$Y,$Q},{$Z,$O}],
    RotorIV = [{$A,$E},{$B,$S},{$C,$O},{$D,$V},{$E,$P},{$F,$Z},{$G,$J},{$H,$A},{$I,$Y},{$J,$Q},{$K,$U},{$L,$I},{$M,$R},{$N,$H},{$O,$X},{$P,$L},{$Q,$N},{$R,$F},{$S,$T},{$T,$G},{$U,$K},{$V,$D},{$W,$C},{$X,$M},{$Y,$W},{$Z,$B}],
    RotorV = [{$A,$V},{$B,$Z},{$C,$B},{$D,$R},{$E,$G},{$F,$I},{$G,$T},{$H,$Y},{$I,$U},{$J,$P},{$K,$S},{$L,$D},{$M,$N},{$N,$H},{$O,$L},{$P,$X},{$Q,$A},{$R,$W},{$S,$M},{$T,$J},{$U,$Q},{$V,$O},{$W,$F},{$X,$E},{$Y,$C},{$Z,$K}],
    % RotorVI = [{$A,$J},{$B,$P},{$C,$G},{$D,$V},{$E,$O},{$F,$U},{$G,$M},{$H,$F},{$I,$Y},{$J,$Q},{$K,$B},{$L,$E},{$M,$N},{$N,$H},{$O,$Z},{$P,$R},{$Q,$D},{$R,$K},{$S,$A},{$T,$S},{$U,$X},{$V,$L},{$W,$I},{$X,$C},{$Y,$T},{$Z,$W}],
    % RotorVII = [{$A,$N},{$B,$Z},{$C,$J},{$D,$H},{$E,$G},{$F,$R},{$G,$C},{$H,$X},{$I,$M},{$J,$Y},{$K,$S},{$L,$W},{$M,$B},{$N,$O},{$O,$U},{$P,$F},{$Q,$A},{$R,$I},{$S,$V},{$T,$L},{$U,$P},{$V,$E},{$W,$K},{$X,$Q},{$Y,$D},{$Z,$T}],
    % RotorVIII = [{$A,$F},{$B,$K},{$C,$Q},{$D,$H},{$E,$T},{$F,$L},{$G,$X},{$H,$O},{$I,$C},{$J,$B},{$K,$J},{$L,$S},{$M,$P},{$N,$D},{$O,$Z},{$P,$R},{$Q,$A},{$R,$M},{$S,$E},{$T,$W},{$U,$N},{$V,$I},{$W,$U},{$X,$Y},{$Y,$G},{$Z,$V}],
    % RotorBeta = [{$A,$L},{$B,$E},{$C,$Y},{$D,$J},{$E,$V},{$F,$C},{$G,$N},{$H,$I},{$I,$X},{$J,$W},{$K,$P},{$L,$B},{$M,$Q},{$N,$M},{$O,$D},{$P,$R},{$Q,$T},{$R,$A},{$S,$K},{$T,$Z},{$U,$G},{$V,$F},{$W,$U},{$X,$H},{$Y,$O},{$Z,$S}],
    % RotorGamma = [{$A,$F},{$B,$S},{$C,$O},{$D,$K},{$E,$A},{$F,$N},{$G,$U},{$H,$E},{$I,$R},{$J,$H},{$K,$M},{$L,$B},{$M,$T},{$N,$I},{$O,$Y},{$P,$C},{$Q,$W},{$R,$L},{$S,$Q},{$T,$P},{$U,$Z},{$V,$X},{$W,$V},{$X,$G},{$Y,$J},{$Z,$D}].
    if
        HdSeq == 'I' ->
            ringSetting(RotorCount,HdSet,HdInit,RotorI),
            sequenceRotor(RlSeq,RotorCount+1,RlSet,RlInit);
        HdSeq == 'II' ->
            ringSetting(RotorCount,HdSet,HdInit,RotorII),
            sequenceRotor(RlSeq,RotorCount+1,RlSet,RlInit);
        HdSeq == 'III' ->
            ringSetting(RotorCount,HdSet,HdInit,RotorIII),
            sequenceRotor(RlSeq,RotorCount+1,RlSet,RlInit);
        HdSeq == 'IV' ->
            ringSetting(RotorCount,HdSet,HdInit,RotorIV),
            sequenceRotor(RlSeq,RotorCount+1,RlSet,RlInit);
        HdSeq == 'V' ->
            ringSetting(RotorCount,HdSet,HdInit,RotorV),
            sequenceRotor(RlSeq,RotorCount+1,RlSet,RlInit);
        RlSeq == [] ->
            io : format("sequenceRotor has finished~n .")
    end.
%this function is to set the ringSetting which valid the key bigger than $Z
ringSetting(CurrentRotorCount,CurrentRingSetting,CurrentInitialSetting,CurrentRotor) ->
    AfterSetting1 = [{M+CurrentRingSetting,N+CurrentRingSetting}||{M,N} <- CurrentRotor],
    AfterSetting2 = [{M-26,N}||{M,N} <- AfterSetting1, M>$Z],
    AfterSetting3 = [{M,N}||{M,N} <- AfterSetting1, M=<$Z],
    AfterSetting4 = AfterSetting2++AfterSetting3,
    AfterSetting5 = [{M,N-26}||{M,N} <- AfterSetting4, N>$Z],
    AfterSetting6 = [{M,N}||{M,N} <- AfterSetting4, N=<$Z],
    FinalSetting7 = AfterSetting5++AfterSetting6,
    initialSetting(CurrentRotorCount,CurrentInitialSetting,FinalSetting7).

%This function to make sure
initialSetting(CurrentRotorCount,CurrentInitialSetting,[{M,N}|Rl]) ->
	if
		M /= $A ->
			Hd = [{M,N}],
			NewList = Rl++Hd,
			initialSetting(CurrentRotorCount,CurrentInitialSetting,NewList);
		M == $A ->
			Hd = [{M,N}],
			NewList = Hd++Rl,
            setRurrentRotor(CurrentRotorCount,NewList)
    end.
    
%Give every Rotor a processID
setRurrentRotor(CurrentRotorCount,CurrentRotor)->
    if 
        CurrentRotorCount == 1 ->
            FirstInRotor = spawn(enigma, inRotor,[]),
            FirstOutRotor = spawn(enigma, outRotor,[]);
        CurrentRotorCount == 2 ->
            SecondInRotor = spawn(enigma, inRotor,[]),
            SecondOutRotor = spawn(enigma, outRotor,[]);
        CurrentRotorCount == 3 ->
            ThirdInRotor = spawn(enigma, inRotor,[]),
            ThirdOutRotor = spawn(enigma, outRotor,[])
    end.    

inRotor(CurrentRotor,Character) ->
    lookup(CurrentRotor,Character).
outRotor(CurrentRotor,Character) ->
    lookupback(CurrentRotor,Character).

%% ====================================================================
%% Rotor
%% ====================================================================



% increment([{M,N}|Rl]) ->
% 	if
% 		M /= $A ->
% 			Hd = [{M,N}],
% 			NewList = Rl++Hd,
% 			initialSetting(CurrentRotorCount,CurrentInitialSetting,NewList);
% 		M == $A ->
% 			Hd = [{M,N}],
% 			NewList = Hd++Rl,
%             setRurrentRotor(CurrentRotorCount,NewList)
%     end.















