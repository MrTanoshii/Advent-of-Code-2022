Declare Function CheckUniqueArrayElements(arr() As String) As Boolean
Function CheckUniqueArrayElements(arr() As String) As Boolean
    Dim As Boolean result = True
    Dim As Integer i
    Dim As Integer j

    ' Compare individual characters
    For i = lBound(arr) To UBound(arr)
        If i > 0 Then
            For j = lBound(arr) To i - 1
                If arr(i) = arr(j) Then
                    result = False
                    ' Exit inner for loop
                    Exit For
                End If
            Next
            ' Exit outer for loop
            If result = False Then
                Exit For
            End If
        End If
    Next

    Return result
End Function

Declare Function CheckUniqueIfNotFound(isFound As Boolean, arr() As String, newValue As String, i as Integer, bufferType As String) As Boolean
Function CheckUniqueIfNotFound(isFound As Boolean, arr() As String, newValue As String, i As Integer, bufferType As String) As Boolean
    Dim As Integer j

    If isFound = False Then
        ' Check if array elements are unique
        arr(i Mod (UBound(arr) + 1)) = newValue
        If i >= (UBound(arr) + 1) Then
            isFound = CheckUniqueArrayElements(arr())

            ' Display result if unique
            If isFound Then
                Print "Found "; bufferType; " at position #"; str$(i); " with characters: ";
                For j = lBound(arr) To UBound(arr)
                    Print arr(j);
                Next
                Print
            End If
        End If
    End If

    Return isFound
End Function

' Variable initialization
Dim As Boolean isMarkerFound = False
Dim As Boolean isMessageFound = False
Dim As Long fileNum = FreeFile
Dim As String markerArray(0 To 3)
Dim As String messageArray(0 To 13)
Dim As String inputStr
Dim As String inputFilename = "./tests/input.txt"

Dim As Integer i = 0

' Open in input reading mode
Open inputFilename For Input lock Read As #fileNum

' Loop through individual characters until EoF
Do
    inputStr = Input(1, #fileNum)
    i = i + 1

    isMarkerFound = CheckUniqueIfNotFound(isMarkerFound, markerArray(), inputStr, i, "marker")
    isMessageFound = CheckUniqueIfNotFound(isMessageFound, messageArray(), inputStr, i, "message")

    if isMarkerFound And isMessageFound Then
        Exit Do
    End If

Loop Until EOF(fileNum)
Close(fileNum)