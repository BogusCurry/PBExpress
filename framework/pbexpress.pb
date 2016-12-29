﻿; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
; PBExpress FastCGI Webframework
; By TroaX aká reVerB - 2016
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;


; -----------------------------------------------------------------------------------------;
; Constants to Setup the Framework
; -----------------------------------------------------------------------------------------;
Enumeration
  #PBExpress_ContentLength = 100
  #PBExpress_OutputBuffer
EndEnumeration

; -----------------------------------------------------------------------------------------;
; Structure for Post-Files
; -----------------------------------------------------------------------------------------;
Structure PBEFiles
  Size.i
  Filename.s
  Buffer.i
EndStructure

; -----------------------------------------------------------------------------------------;
; PBExpress-Module Declararion
; -----------------------------------------------------------------------------------------;
DeclareModule PBExpress
  Declare.b AddRouteKey(KeyString.s)
  Declare.b AddRoute(Route.s,CallBack.i)
  Declare.b SetOption(Option.i,Value.i)
  Declare.b RunServer()
  Declare.b SetDefaultPage(CallBack.i)
  Declare SetCookie(Name.s,Value.s,Expires.i = 0,Secure.b = #False,HTTPOnly.b = #False)
  Declare.s GetCookie(Name.s)
  Declare.b Header(Type.s,Value.s,Flags.i = #PB_UTF8)
  Declare Output(OutStr.s)
  Declare.b SendFile(FileName.s,Show.b = #False,Cache = #True)
  Declare.b SendBufferAsFile(FileName.s,Buffer.i,Length.i,Show.b = #False,Cache = #True)
EndDeclareModule

; -----------------------------------------------------------------------------------------;
; The PBExpress-Module
; -----------------------------------------------------------------------------------------;
Module PBExpress
  ; -----------------------------------------------------------------------------------------;
  ; The MIME-Type List
  ; -----------------------------------------------------------------------------------------;
  NewMap HTTPFileTypes.s()
  HTTPFileTypes("jar") = "application/java-archive"
  HTTPFileTypes("json") = "application/json"
  HTTPFileTypes("pdf") = "application/pdf"
  HTTPFileTypes("crl") = "application/pkcs-crl"
  HTTPFileTypes("ps") = "application/postscript"
  HTTPFileTypes("ai") = "application/postscript"
  HTTPFileTypes("kml") = "application/vnd.google-earth.kml+xml"
  HTTPFileTypes("kmz") = "application/vnd.google-earth.kmz"
  HTTPFileTypes("xml") = "application/xml"
  HTTPFileTypes("xsl") = "application/xml"
  HTTPFileTypes("bin") = "application/x-binary"
  HTTPFileTypes("bz2") = "application/x-bzip2"
  HTTPFileTypes("deb") = "application/x-debian-package"
  HTTPFileTypes("dvi") = "application/x-dvi"
  HTTPFileTypes("gz") = "application/x-gzip"
  HTTPFileTypes("class") = "application/x-java-vm"
  HTTPFileTypes("latex") = "application/x-latex"
  HTTPFileTypes("com") = "application/x-msdos-program"
  HTTPFileTypes("exe") = "application/x-msdos-program"
  HTTPFileTypes("bat") = "application/x-msdos-program"
  HTTPFileTypes("rpm") = "application/x-redhat-packet-manager"
  HTTPFileTypes("swf") = "application/x-shockwave-flash"
  HTTPFileTypes("sh") = "application/x-sh"
  HTTPFileTypes("tgz") = "application/x-tar"
  HTTPFileTypes("bak") = "application/x-trash"
  HTTPFileTypes("crt") = "application/x-x509-ca-cert"
  HTTPFileTypes("cer") = "application/x-x509-ca-cert"
  HTTPFileTypes("zip") = "application/zip"
  HTTPFileTypes("xls") = "application/excel"
  HTTPFileTypes("xlb") = "application/excel"
  HTTPFileTypes("xlc") = "application/excel"
  HTTPFileTypes("mdb") = "application/msaccess"
  HTTPFileTypes("doc") = "application/msword"
  HTTPFileTypes("ppt") = "application/powerpoint"
  HTTPFileTypes("pps") = "application/powerpoint"
  HTTPFileTypes("pptx") = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  HTTPFileTypes("xlsx") = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  HTTPFileTypes("docx") = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  HTTPFileTypes("odg") = "application/vnd.oasis.opendocument.graphics"
  HTTPFileTypes("odp") = "application/vnd.oasis.opendocument.presentation"
  HTTPFileTypes("ods") = "application/vnd.oasis.opendocument.spreadsheet"
  HTTPFileTypes("odt") = "application/vnd.oasis.opendocument.text"
  HTTPFileTypes("au") = "audio/basic"
  HTTPFileTypes("mid") = "audio/midi"
  HTTPFileTypes("midi") = "audio/midi"
  HTTPFileTypes("m4a") = "audio/mp4a-latm"
  HTTPFileTypes("m4b") = "audio/mp4a-latm"
  HTTPFileTypes("mp3") = "audio/mpeg"
  HTTPFileTypes("ogg") = "audio/ogg"
  HTTPFileTypes("aac") = "audio/x-aac"
  HTTPFileTypes("wav") = "audio/x-wav"
  HTTPFileTypes("bmp") = "image/bmp"
  HTTPFileTypes("gif") = "image/gif"
  HTTPFileTypes("jpg") = "image/jpeg"
  HTTPFileTypes("jpeg") = "image/jpeg"
  HTTPFileTypes("pcx") = "image/pcx"
  HTTPFileTypes("png") = "image/png"
  HTTPFileTypes("svg") = "image/svg+xml"
  HTTPFileTypes("tiff") = "image/tiff"
  HTTPFileTypes("nol") = "image/vnd.nok-oplogo-color"
  HTTPFileTypes("ico") = "image/x-icon"
  HTTPFileTypes("cache") = "text/cache-manifest"
  HTTPFileTypes("ics") = "text/calendar"
  HTTPFileTypes("css") = "text/css"
  HTTPFileTypes("csv") = "text/csv"
  HTTPFileTypes("htm") = "text/html"
  HTTPFileTypes("html") = "text/html"
  HTTPFileTypes("js") = "text/javascript"
  HTTPFileTypes("asc") = "text/plain"
  HTTPFileTypes("asm") = "text/plain"
  HTTPFileTypes("txt") = "text/plain"
  HTTPFileTypes("text") = "text/plain"
  HTTPFileTypes("diff") = "text/plain"
  HTTPFileTypes("java") = "text/plain"
  HTTPFileTypes("rtf") = "text/richtext"
  HTTPFileTypes("wml") = "text/vnd.wap.wml"
  HTTPFileTypes("c") = "text/x-c"
  HTTPFileTypes("c++") = "text/x-c++src"
  HTTPFileTypes("cpp") = "text/x-c++src"
  HTTPFileTypes("cxx") = "text/x-c++src"
  HTTPFileTypes("p") = "text/x-pascal"
  HTTPFileTypes("tcl") = "text/x-tcl"
  HTTPFileTypes("tex") = "text/x-tex"
  HTTPFileTypes("ltx") = "text/x-tex"
  HTTPFileTypes("sty") = "text/x-tex"
  HTTPFileTypes("3gp") = "video/3gpp"
  HTTPFileTypes("3gpp") = "video/3gpp"
  HTTPFileTypes("avi") = "video/avi"
  HTTPFileTypes("mkv") = "video/x-matroska"
  HTTPFileTypes("mpeg") = "video/mpeg"
  HTTPFileTypes("mpg") = "video/mpeg"
  HTTPFileTypes("mpe") = "video/mpeg"
  HTTPFileTypes("mp4") = "video/mp4"
  HTTPFileTypes("qt") = "video/quicktime"
  HTTPFileTypes("flv") = "video/flv"
  HTTPFileTypes("asf") = "video/x-ms-asf"
  HTTPFileTypes("asr") = "video/x-ms-asf"
  HTTPFileTypes("flr") = "x-world/x-vrml"
  HTTPFileTypes("vrm") = "x-world/x-vrml"
  HTTPFileTypes("vrml") = "x-world/x-vrml"
  HTTPFileTypes("wrl") = "x-world/x-vrml"
  HTTPFileTypes("wrz") = "x-world/x-vrml"
  HTTPFileTypes("xaf") = "x-world/x-vrml"
  
  ; -----------------------------------------------------------------------------------------;
  ; Constants to Setup the Framework
  ; -----------------------------------------------------------------------------------------;
  Enumeration
    #PBExpress_ContentLength = 100
    #PBExpress_OutputBuffer
  EndEnumeration
  
  ; -----------------------------------------------------------------------------------------;
  ; Expression For forbidden Signs
  ; -----------------------------------------------------------------------------------------;
  CreateRegularExpression(1001,"[\s\W]",#PB_RegularExpression_NoCase)
  
  ; -----------------------------------------------------------------------------------------;
  ; The Hash for the Route-ID
  ; -----------------------------------------------------------------------------------------;
  UseMD5Fingerprint()
  
  
  ; -----------------------------------------------------------------------------------------;
  ; Structure for Post-Files
  ; -----------------------------------------------------------------------------------------;
  Structure PBEFiles
    Size.i
    Filename.s
    Buffer.i
  EndStructure
  
  ; -----------------------------------------------------------------------------------------;
  ; Basic Initializing for important constructs
  ; -----------------------------------------------------------------------------------------;
  Prototype.i Routeapp(Map Request.s(),Map Get.s(),Map Post.s(),Map Files.PBEFiles())
  NewList Keys.s()
  NewMap Routes.i()
  Define.RouteApp DefaultPage
  
  ; -----------------------------------------------------------------------------------------;
  ; Configuration-Structure
  ; -----------------------------------------------------------------------------------------;
  Structure PBEConfig
    MaxContentLength.i
    OutputBuffer.b
  EndStructure
  
  Define Config.PBEConfig
  Config\MaxContentLength = 131072               ; Default: 128 KB
  Config\OutputBuffer = #False
  
  ; -----------------------------------------------------------------------------------------;
  ; Procedure to Change Settings
  ; -----------------------------------------------------------------------------------------;
  Procedure.b SetOption(Option.i, Value.i)
    Shared Config
    Select Option
      Case #PBExpress_ContentLength
        If Value < 10240
          Config\MaxContentLength = Value * 1024
          ProcedureReturn #True
        Else
          ProcedureReturn #False
        EndIf
      Case #PBExpress_OutputBuffer
        Select Value
          Case #True
            Config\OutputBuffer = #True
            ProcedureReturn #True
          Case #False
            Config\OutputBuffer = #False
            ProcedureReturn #True
          Default
            ProcedureReturn #False
        EndSelect
      Default
        ProcedureReturn #False
    EndSelect
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Procedure to Parse Routes with an Fake URL and the HTTP-Library
  ; -----------------------------------------------------------------------------------------;
  Procedure.s ParseKeys(StrToParse.s)
    Define.s FakeURL = "a://b.c/?" + StrToParse
    Define.s RouteString = ""
    Shared Keys()
  
    ForEach Keys()
      RouteString + Keys() + ":" + GetURLPart(FakeURL,Keys()) + ";"
    Next
    ProcedureReturn StringFingerprint(RouteString,#PB_Cipher_MD5)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Procedure to Set the Default-Page
  ; -----------------------------------------------------------------------------------------;
  Procedure.b SetDefaultPage(CallBack.i)
    Shared DefaultPage
    If CallBack > 0
      DefaultPage = CallBack
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Add a Route-Key to use for the Routeparser
  ; -----------------------------------------------------------------------------------------;
  Procedure.b AddRouteKey(KeyString.s)
    Shared Keys()
    If Not MatchRegularExpression(1001,KeyString)
      AddElement(Keys()) : Keys() = KeyString
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Add a Route to the Routing-Table
  ; -----------------------------------------------------------------------------------------;
  Procedure.b AddRoute(Route.s,CallBack.i)
    Shared Keys()
    Shared Routes.i()
    If ListSize(Keys()) > 0
      Define.s RouteString = ParseKeys(Route)
      If Not RouteString = ""
        Routes(RouteString) = CallBack
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Alias for WriteCGIHeader
  ; -----------------------------------------------------------------------------------------;
  Procedure.b Header(type.s,value.s,flags.i = #PB_UTF8)
    If WriteCGIHeader(type,value,flags)
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Output-Procedure
  ; -----------------------------------------------------------------------------------------;
  Define.s CacheString
  Procedure Output(OutStr.s)
    Shared CacheString
    Shared Config
    If Config\OutputBuffer
      CacheString + OutStr
    Else
      WriteCGIStringN(OutStr.s)
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Start SetCookie-Routine
  ; -----------------------------------------------------------------------------------------;
  Dim Days.s(6)
  Days(0) = "Sun"
  Days(1) = "Mon"
  Days(2) = "Tue"
  Days(3) = "Wed"
  Days(4) = "Thu"
  Days(5) = "Fri"
  Days(6) = "Sat"
  
  Dim Months.s(11)
  Months(0) = "Jan"
  Months(1) = "Feb"
  Months(2) = "Mar"
  Months(3) = "Apr"
  Months(4) = "May"
  Months(5) = "Jun"
  Months(6) = "Jul"
  Months(7) = "Aug"
  Months(8) = "Sep"
  Months(9) = "Oct"
  Months(10) = "Nov"
  Months(11) = "Dec"
  
  Procedure.s CheckDoubleDigit(Digits.i)
    If Digits < 10
      ProcedureReturn "0" + Str(Digits)
    Else
      ProcedureReturn Str(Digits)
    EndIf
  EndProcedure
  
  Procedure SetCookie(Name.s,Value.s,Expires.i = 0,Secure.b = #False,HTTPOnly.b = #False)
    Shared Days()
    Shared Months()
    Define.s CookieString
    CookieString = URLEncoder(Name) + "=" + URLEncoder(Value)
    If Expires
      CookieString + "; expires=" + Days(DayOfWeek(Expires)) 
      CookieString + ", " + CheckDoubleDigit(Day(Expires)) + "-" + Months(Month(Expires)-1) + "-" + Str(Year(Expires))
      CookieString + " " + CheckDoubleDigit(Hour(Expires)) + ":" + CheckDoubleDigit(Minute(Expires)) + ":" + CheckDoubleDigit(Second(Expires))
      CookieString + " GMT"
    EndIf
    If Secure
      CookieString + "; secure"
    EndIf
    If HTTPOnly
      CookieString + "; httponly"
    EndIf
    WriteCGIHeader(#PB_CGI_HeaderSetCookie,CookieString)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ;  GetCookie-Routine
  ; -----------------------------------------------------------------------------------------;
  Procedure.s GetCookie(Name.s)
    If CountCGICookies()
      ProcedureReturn CGICookieValue(Name)
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ;  Send File to Browser
  ; -----------------------------------------------------------------------------------------;
  Procedure.b SendFile(FileName.s,Show.b = #False,Cache = #True)
    Shared HTTPFileTypes()
    Protected.s Disposition,Extension,File,ContentType,First,Second
    Extension = GetExtensionPart(Filename)
    If Len(Extension) = 0
      ProcedureReturn #False
    EndIf
    If OpenFile(0,FileName)
      CloseFile(0)
      File = GetFilePart(Filename)
      Disposition + "filename="+File
      If FindMapElement(HTTPFileTypes(),Extension)
        ContentType = HTTPFileTypes()
        First = StringField(ContentType,1,"/")
        Second = StringField(ContentType,2,"/")
        If (First = "video" Or First = "audio" Or First = "image" Or First = "text" Or Second = "pdf") And Show
          Disposition = Disposition
        Else
          Disposition = "attachment; " + Disposition
        EndIf
      Else
        ContentType = "application/octet-stream"
        Disposition = "attachment; " + Disposition
      EndIf
      WriteCGIHeader(#PB_CGI_HeaderContentType, ContentType)
      If Not Cache
        WriteCGIHeader(#PB_CGI_HeaderPragma, "no-cache")
      EndIf
      WriteCGIHeader(#PB_CGI_HeaderContentDisposition, Disposition, #PB_CGI_LastHeader)
      WriteCGIFile(FileName)
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ;  Send Buffer as File to Browser
  ; -----------------------------------------------------------------------------------------;
  Procedure.b SendBufferAsFile(FileName.s,Buffer.i,Length.i,Show.b = #False,Cache = #True)
    Shared HTTPFileTypes()
    Protected.s Disposition,Extension,File,ContentType,First,Second
    If Buffer = 0 And Length = 0
      ProcedureReturn #False
    EndIf
    Extension = GetExtensionPart(Filename)
    File = GetFilePart(Filename)
    If Len(Extension) = 0
      ProcedureReturn #False
    Else
      Disposition + "filename="+File
      If FindMapElement(HTTPFileTypes(),Extension)
        ContentType = HTTPFileTypes()
        First = StringField(ContentType,1,"/")
        Second = StringField(ContentType,2,"/")
        If (First = "video" Or First = "audio" Or First = "image" Or First = "text" Or Second = "pdf") And Show
          Disposition = "inline; " + Disposition
        Else
          Disposition = "attachment; " + Disposition
        EndIf
      Else
        ContentType = "application/octet-stream"
        Disposition = "attachment; " + Disposition
      EndIf
      Debug Disposition
      WriteCGIHeader(#PB_CGI_HeaderContentType, ContentType)
      If Not Cache
        WriteCGIHeader(#PB_CGI_HeaderPragma, "no-cache")
      EndIf
      WriteCGIHeader(#PB_CGI_HeaderContentDisposition, Disposition, #PB_CGI_LastHeader)
      WriteCGIData(Buffer, Length)
      ProcedureReturn #True
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------------;
  ; Run the Server
  ; -----------------------------------------------------------------------------------------;
  Procedure.b RunServer()
    Shared Config
    Shared Routes()
    Shared DefaultPage
    Shared CacheString
    NewMap Request.s()
    NewMap Post.s()
    NewMap Get.s()
    NewMap Files.PBEFiles()
    Define.i CntLen, BufferLen
    Define.s RequestType, ContentType, QueryString
    
    While WaitFastCGIRequest()
      BufferLen = ReadCGI()
      If BufferLen
        ; #### Get Operation Header-Data #### ;
        CntLen = Val(CGIVariable(#PB_CGI_ContentLength))
        RequestType = CGIVariable(#PB_CGI_RequestMethod)
        QueryString = CGIVariable(#PB_CGI_QueryString)
        ContentType = CGIVariable(#PB_CGI_ContentType)
        
        ; #### Check the Length of the Request-Body #### ;
        If CntLen > Config\MaxContentLength
          WriteCGIHeader(#PB_CGI_HeaderStatus, "413", #PB_CGI_LastHeader)
          WriteCGIStringN("<h1>413</h1><p>Request Entity Too Large: The Requestbody-Limit is " + Str(Config\MaxContentLength) + " Bytes</p>")
          Continue
        EndIf
        
        ; #### Parsing URL Key-Values to Create Get-List #### ;
        If Not QueryString = ""
          Define.i QCounter = CountString(QueryString,"&")
          Define.i C
          Define.s Snippet
          For C = 1 To QCounter + 1
            Snippet = StringField(QueryString,C,"&")
            If CountString(Snippet,"0") = 2
              Get(StringField(Snippet,1,"0")) = StringField(Snippet,2,"0")
            EndIf
          Next C
        EndIf
        
        ; #### Count CGI-Parameter
        Define.i ParamCount = CountCGIParameters()
        
        ; #### Collecting POST-Data #### ;
        If (RequestType = "POST" Or RequestType = "PUT") And ContentType = "application/x-www-form-urlencoded"
          Define.i CP
          For CP = 0 To ParamCount - 1
            If CGIParameterType("",CP) = #PB_CGI_Text
              Post(CGIParameterName(CP)) = CGIParameterValue("",CP)
            EndIf
          Next CP
          If ParamCount = 0
            WriteCGIHeader(#PB_CGI_HeaderStatus, "400", #PB_CGI_LastHeader)
            WriteCGIStringN("<h1>400</h1><p>Bad Request: Invalid Requestbody</p>")
            Continue
          EndIf
        EndIf
        
        ; #### Collecting POST-Data with Files #### ;
        If (RequestType = "POST" Or RequestType = "PUT") And Left(ContentType,19) = "multipart/form-data"
          Define.i CP
          For CP = 0 To ParamCount - 1
            If CGIParameterType("",CP) = #PB_CGI_Text
              Post(CGIParameterName(CP)) = CGIParameterValue("",CP)
            Else
              Files(CGIParameterName(CP))\Buffer = CGIParameterData("",CP)
              Files(CGIParameterName(CP))\Filename = CGIParameterValue("",CP)
              Files(CGIParameterName(CP))\Size = CGIParameterDataSize("",CP)
            EndIf
          Next CP
          If ParamCount = 0
            WriteCGIHeader(#PB_CGI_HeaderStatus, "400", #PB_CGI_LastHeader)
            WriteCGIStringN("<h1>400</h1><p>Bad Request: Invalid Requestbody</p>")
            Continue
          EndIf
        EndIf
        
        ; #### Write JSON in the JSON-Key of Post() #### ;
        If (RequestType = "POST" Or RequestType = "PUT") And ContentType = "application/json" And ParamCount = 0 And CntLen > 0
          Define.i CntBuffer = CGIBuffer()
          Define.i TempJson = CatchJSON(#PB_Any,CntBuffer,CntLen)
          If TempJson
            Post("JSON") = PeekS(CntBuffer,CntLen,#PB_UTF8)
            FreeJSON(TempJson)
          Else
            WriteCGIHeader(#PB_CGI_HeaderStatus, "400", #PB_CGI_LastHeader)
            WriteCGIStringN("<h1>400</h1><p>Bad Request: Invalid JSON-String</p>")
            Continue
          EndIf
        EndIf
        
        ; #### Get HTTP-Requestheader-Data ####;
        Request("AuthType") = CGIVariable(#PB_CGI_AuthType)
        Request("ContentLength") = Str(CntLen.i)
        Request("ContentType") = ContentType
        Request("DocumentRoot") = CGIVariable(#PB_CGI_DocumentRoot)
        Request("GatewayInterface") = CGIVariable(#PB_CGI_GatewayInterface)
        Request("PathInfo") = CGIVariable(#PB_CGI_PathInfo)
        Request("PathTranslated") = CGIVariable(#PB_CGI_PathTranslated)
        Request("QueryString") = QueryString
        Request("RemoteAddr") = CGIVariable(#PB_CGI_RemoteAddr)
        Request("RemoteHost") = CGIVariable(#PB_CGI_RemoteHost)
        Request("RemoteIdent") = CGIVariable(#PB_CGI_RemoteIdent)
        Request("RemotePort") = CGIVariable(#PB_CGI_RemotePort)
        Request("RemoteUser") = CGIVariable(#PB_CGI_RemoteUser)
        Request("RequestURI") = CGIVariable(#PB_CGI_RequestURI)
        Request("RequestMethod") = RequestType
        Request("ScriptName") = CGIVariable(#PB_CGI_ScriptName)
        Request("ServerAdmin") = CGIVariable(#PB_CGI_ServerAdmin)
        Request("ServerName") = CGIVariable(#PB_CGI_ServerName)
        Request("ServerPort") = CGIVariable(#PB_CGI_ServerPort)
        Request("ServerProtocol") = CGIVariable(#PB_CGI_ServerProtocol)
        Request("ServerSignature") = CGIVariable(#PB_CGI_ServerSignature)
        Request("ServerSoftware") = CGIVariable(#PB_CGI_ServerSoftware)
        Request("HttpAccept") = CGIVariable(#PB_CGI_HttpAccept)
        Request("HttpAcceptEncoding") = CGIVariable(#PB_CGI_HttpAcceptEncoding)
        Request("HttpAcceptLanguage") = CGIVariable(#PB_CGI_HttpAcceptLanguage)
        Request("HttpCookie") = CGIVariable(#PB_CGI_HttpCookie)
        Request("HttpForwarded") = CGIVariable(#PB_CGI_HttpForwarded)
        Request("HttpHost") = CGIVariable(#PB_CGI_HttpHost)
        Request("HttpPragma") = CGIVariable(#PB_CGI_HttpPragma)
        Request("HttpReferer") = CGIVariable(#PB_CGI_HttpReferer)
        Request("HttpUserAgent") = CGIVariable(#PB_CGI_HttpUserAgent)
        
        If QueryString = ""
          DefaultPage(Request(),Get(),Post(),Files())
          If Config\OutputBuffer
            Shared CacheString
            WriteCGIString(CacheString,#PB_UTF8)
            CacheString = ""
          EndIf
        Else
          Define.s ParsedRoute = ParseKeys(QueryString)
          If ParsedRoute = ""
            WriteCGIHeader(#PB_CGI_HeaderStatus, "404", #PB_CGI_LastHeader)
            WriteCGIStringN("<h1>404</h1><p>Website Not found</p>")
          Else
            If FindMapElement(Routes(),ParsedRoute)
              Define.RouteApp app = Routes(ParsedRoute)
              app(Request(),Get(),Post(),Files())
              If Config\OutputBuffer
                Shared CacheString
                WriteCGIString(CacheString,#PB_UTF8)
                CacheString = ""
              EndIf
            Else
              WriteCGIHeader(#PB_CGI_HeaderStatus, "404", #PB_CGI_LastHeader)
              WriteCGIStringN("<h1>404</h1><p>Website Not found</p>")
            EndIf
          EndIf
        EndIf
      EndIf
      BufferLen = 0
      CntLen = 0
      RequestType = ""
      QueryString = ""
      ClearMap(Request())
      ClearMap(Post())
      ClearMap(Get())
      ClearMap(Files())
    Wend
    ProcedureReturn #False
  EndProcedure
EndModule
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 445
; FirstLine = 418
; Folding = ---
; EnableThread
; EnableXP
; CompileSourceDirectory
; Compiler = PureBasic 5.51 (Windows - x64)
; EnableUnicode