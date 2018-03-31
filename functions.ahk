﻿;; CRND(x1, x2, y1, y2, hwnd)
;; Randomly left click once in a square area with top left (x1, y1), bottom right (x2, y2)
CRND(x1, x2, y1, y2, hwnd){
  global ts
  random, xrr, x1, x2
  random, yrr, y1, y2
  ts.moveto(xrr, yrr)
  mysleep(10, 10)
  ts.leftclick()
  mysleep(10, 10)
}

;; WTFC1(colx, coly, coll, x1, x2, y1, y2, zzz, hwnd, adv)
;; explanation will be given soon
WTFC1(colx, coly, coll, x1, x2, y1, y2, zzz, hwnd, adv){
  global ts
  j := 0
  flgj :=0
  while (j = 0){
    coltest := ts.GetColor(colx, coly)
    ;OutputDebug, % coltest
    if ((coltest = coll and zzz = 0) or (coltest <> coll and zzz = 1)) {
      flgj := 1
    }
    if (flgj = 1) {
      CRND(x1, x2, y1, y2, hwnd)
      mysleep(1000, 333)
      if (adv = 0) {
        j := 1
      }
      coltest2 := ts.GetColor(colx, coly)
      if ((coltest2 = coll and zzz = 1) or (coltest2 <> coll and zzz = 0)) {
        j := 1
      }
    }
  }
}

REJXS(hwnd){
  colxs := ts.GetColor(755, 465)
  if (colxs = "dc715f"){
    CRND(755-5, 755+5, 465-5, 465+5, hwnd)
    OutputDebug, % "successfully rejected 1 XUAN-SHANG"
  }
  sleep, 50
}

;;mysleep
mysleep(slpa, slpb){
  random, slpbr, 0, slpb
  sleep, slpa + slpbr
}

; ComVar: Creates an object which can be used to pass a value ByRef.
;   ComVar[] retrieves the value.
;   ComVar[] := Val sets the value.
;   ComVar.ref retrieves a ByRef object for passing to a COM function.
ComVar(Type=0xC)
{
    static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
    ; Create an array of 1 VARIANT.  This method allows built-in code to take
    ; care of all conversions between VARIANT and AutoHotkey internal types.
    arr := ComObjArray(Type, 1)
    ; Lock the array and retrieve a pointer to the VARIANT.
    DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
    ; Store the array and an object which can be used to pass the VARIANT ByRef.
    return { ref: ComObject(0x4000|Type, arr_data), _: arr, base: base }
}

ComVarGet(cv, p*) { ; Called when script accesses an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]
        return cv._[0]
}

ComVarSet(cv, v, p*) { ; Called when script sets an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]:=v
        return cv._[0] := v
}

ComVarDel(cv) { ; Called when the object is being freed.
    ; This must be done to allow the internal array to be freed.
    DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}