' cadenas comunes
Dim Shared As String sa, sb

' enteros
Dim Shared As Integer a, b, c, d, e, f, g, h, i


Dim Shared As Integer cuadro=0
Dim Shared As Integer tenemos_cuadro=0=0
Dim Shared As Integer paleta(15,2) ' 16 colores RGB
Dim Shared As short coordenadas(1000,1) ' 2d X e Y
Dim Shared As short vertices(1000,20) ' color y 3 o 4 vertices
Dim Shared As short verticesidx=0 ' determina si el poligono son vertices a coordenadas, o coordenadas directas
Dim Shared As integer clr ' si se debe borrar la pantalla en el cuadro actual


Dim shared As Integer RESX,RESY,escala
escala=4 ' x4 para llevar la resolucion original 255x200 a 4 veces su tamaño
RESX=256*escala
RESY=200*escala
Screenres RESX,RESY,32,2

Sub fill_polygon(a() As Short, bound As Integer, ByVal c As integer)
   'translation of a c snippet by Angad
   ' jepalza: variable "bound"
   'source of c code: http://code-heaven.blogspot.it/2009/10/simple-c-program-for-scan-line-polygon.html
   Dim As Long      i, j, k, dy, dx, x, y, temp
   Dim As Long      xi(0 to bound)
   Dim As Single    slope(0 to bound)
   
   'join first and last vertex
   a(bound, 0) = a(0, 0)
   a(bound, 1) = a(0, 1)

   For i = 0 To bound - 1

      dy = a(i+1, 1) - a(i, 1)
      dx = a(i+1, 0) - a(i, 0)

      If (dy = 0) Then slope(i) = 1.0
      If (dx = 0) Then slope(i) = 0.0

      If (dy <> 0) AndAlso (dx <> 0) Then slope(i) = dx / dy
   Next i

   For y = 0 to RESX - 1
      k = 0
      ' using FB's short-cut operators (which C doesn't have!)
      For i = 0 to bound - 1
         If (a(i, 1) <= y AndAlso a(i+1, 1) > y) OrElse _
             (a(i, 1) > y AndAlso a(i+1, 1) <= y) Then
            xi(k) = CLng(a(i, 0) + slope(i) * (y - a(i, 1)))
            k += 1
         End If
      Next i

      For j = 0 to k - 2
         'Arrange x-intersections in order
         For i = 0 To k - 2
            If (xi(i) > xi(i + 1)) Then
               temp = xi(i)
               xi(i) = xi(i + 1)
               xi(i + 1) = temp
            End If
         Next i
      Next j
      'line filling
      For i = 0 To k - 2 Step 2
         Line (xi(i), y)-(xi(i + 1) + 1, y), c
      Next i
   Next y
End Sub


Sub dibuja_cuadro()

	dim as integer i=0
	dim as integer h,e,f,a
	Dim As short aa(20,1) ' max. 21 vertices (creo que solo llega a 5 maximo)
	
	While vertices(i,0)<>-1 
		
		e=vertices(i,0) ' color
		
		If e>100 Then ' estamos ante un poligono especial, con coordenadas directas sin indices de vertices
			e=e-100 ' dejamos el color en su rango (de 0 a 15)
			f=RGB(paleta(e,0),paleta(e,1),paleta(e,2))
			h=0 ' nuevo poligono
			For e=1 To 20 Step 2
				a=vertices(i,e)
				b=vertices(i,e+1)
				If a=-1 Then Exit For
				aa(h,0)=a 'x
				aa(h,1)=b 'y
				h+=1
			Next
		Else ' si color <100 es un poligono tradicional, basado en indices a coordenadas segun vertices
			f=RGB(paleta(e,0),paleta(e,1),paleta(e,2))
			h=0 ' nuevo poligono
			For e=1 To 20
				a=vertices(i,e)
				If a=-1 Then Exit For
				aa(h,0)=coordenadas(a,0) 'x
				aa(h,1)=coordenadas(a,1) 'y
				h+=1
			Next
		endif
	
	  ' ---------------------
		 fill_polygon(aa(),h,f)
	  ' ---------------------
		
		i+=1
	Wend

End Sub


Open "STNICCC_2000_demo.txt" For Input As 1

While Not Eof(1)
	Line Input #1, sa

	If InStr(sa,"clr"+Chr(34)) Then ' borrar pantalla SI o NO
		If InStr(LCase(sa),"true") Then clr=TRUE
		If InStr(LCase(sa),"false") Then clr=FALSE
		verticesidx=0 ' aprovecho aqui a poner a cero el indicador de poligono
	EndIf
	
	If InStr(sa,"palette") Then
		verticesidx=0 ' aprovecho aqui a poner a cero el indicador de poligono
		' al encontrar PALETTE sabemos que es CUADRO nuevo, por lo que dibujamos el actual almacenado
		If tenemos_cuadro=1 Then
			' nota: en FB usando segunda pantalla para dibujar, se puede borrar siempre
			'If clr Then Cls ' solo borra si se lo indica el cuadro actual
			' asi que anulo lo del borrado segun cuadro, y borro siempre
			ScreenLock
			Color RGB(0,0,0),RGB(120,100,0) ' en la demo original, el fondo es negro, pero yo lo prefiero amarillo
			Cls
			dibuja_cuadro()
			ScreenUnLock
			ScreenCopy
			Locate 1,1:Print cuadro
			Sleep 40 ' velocidad de refresco
			tenemos_cuadro=0 ' liberamos el cuadro
		EndIf
		For f=0 To 15
			Line Input #1, sa
			sa=Mid(sa,InStr(sa,"#")+1,6)
			paleta(f,0)=Val("&h"+Mid(sa,1,2))
			paleta(f,1)=Val("&h"+Mid(sa,3,2))
			paleta(f,2)=Val("&h"+Mid(sa,5,2))
		Next
		cuadro+=1
	EndIf
	
	If (InStr(sa,"vertices"+Chr(34))) OrElse (h>0) AndAlso (verticesidx=0) Then ' verticesidx es para evitar que confunda con los del poligono
		If h=0 Then Line Input #1, sa
		If InStr(sa,"]") Then h=0:GoTo salir
		sb=Mid(sa,InStr(sa,"x")+3)
		sa=Mid(sa,InStr(sa,"y")+3)
		coordenadas(h,0)=val(sb)*escala
		coordenadas(h,1)=val(sa)*escala
		h+=1
	EndIf	

	If InStr(sa,"polygons") Then
		Line Input #1, sa
		If InStr(sa,"verticesIdx") Then verticesidx=1
		If InStr(sa,"vertices"+Chr(34)) Then verticesidx=2
	EndIf
	
	' tipo VERTICESIDX
	If verticesidx=1 Then
		If InStr(sa,"colidx")=0 Then ' no hay mas, salimos
			' la ultima, ponemos "-1" en el color y salimos. ese "-1" lo usare mas tarde para saber donde dejar de leer
			vertices(i,0)=-1
			i=0
			tenemos_cuadro=1
			verticesidx=0
			GoTo salir
		EndIf
		sa=Mid(sa,InStr(sa,"colidx")+8)
		vertices(i,0)=val(sa) ' color
		For f=1 To 20 ' suficiente para buscar todos los IDX
			a=InStr(sa,"idx")
			If a=0 Then vertices(i,f)=-1:Exit For
			sa=Mid(sa,a+5)
			vertices(i,f)=val(sa)
		Next	
		i+=1
	EndIf		

	' tipo VERTICES a secas
	If verticesidx=2 Then
		If InStr(sa,"colidx")=0 Then ' no hay mas, salimos
			' la ultima, ponemos "-1" en el color y salimos. ese "-1" lo usare mas tarde para saber donde dejar de leer
			vertices(i,0)=-1
			i=0
			tenemos_cuadro=1
			verticesidx=0
			GoTo salir
		EndIf
		sa=Mid(sa,InStr(sa,"colidx")+8)
		vertices(i,0)=val(sa)+100 ' color+100 para dar a entender que este poligono es de coordenadas, no de vertices
		For f=1 To 20 Step 2 ' suficiente para buscar todos los X e Y
			a=InStr(sa,"x")
			If a=0 Then vertices(i,f)=-1:Exit For
			sa=Mid(sa,a+3)
			vertices(i,f)=val(sa)*escala
			a=InStr(sa,"y")
			sa=Mid(sa,a+3)
			vertices(i,f+1)=val(sa)*escala
			'Print i,vertices(i,f),vertices(i,f+1):ScreenCopy:sleep
		Next	
		i+=1
	EndIf		
	
	salir:
	If InKey=Chr(27) Then Exit While 
Wend



Close 1
Print "...FIN"
sleep