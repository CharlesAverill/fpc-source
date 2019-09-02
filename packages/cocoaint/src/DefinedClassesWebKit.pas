{$mode delphi}
{$modeswitch objectivec1}
{$modeswitch cvar}
{$packrecords c}

unit DefinedClassesWebKit;
interface

type
  DOMAbstractView = objcclass external;
  DOMAttr = objcclass external;
  DOMBlob = objcclass external;
  DOMCDATASection = objcclass external;
  DOMCSSCharsetRule = objcclass external;
  DOMCSSFontFaceRule = objcclass external;
  DOMCSSImportRule = objcclass external;
  DOMCSSMediaRule = objcclass external;
  DOMCSSPageRule = objcclass external;
  DOMCSSPrimitiveValue = objcclass external;
  DOMCSSRule = objcclass external;
  DOMCSSRuleList = objcclass external;
  DOMCSSStyleDeclaration = objcclass external;
  DOMCSSStyleRule = objcclass external;
  DOMCSSStyleSheet = objcclass external;
  DOMCSSUnknownRule = objcclass external;
  DOMCSSValue = objcclass external;
  DOMCSSValueList = objcclass external;
  DOMCharacterData = objcclass external;
  DOMComment = objcclass external;
  DOMCounter = objcclass external;
  DOMDocument = objcclass external;
  DOMDocumentFragment = objcclass external;
  DOMDocumentType = objcclass external;
  DOMElement = objcclass external;
  DOMEntity = objcclass external;
  DOMEntityReference = objcclass external;
  DOMEvent = objcclass external;
  DOMFile = objcclass external;
  DOMFileList = objcclass external;
  DOMHTMLAnchorElement = objcclass external;
  DOMHTMLAppletElement = objcclass external;
  DOMHTMLAreaElement = objcclass external;
  DOMHTMLBRElement = objcclass external;
  DOMHTMLBaseElement = objcclass external;
  DOMHTMLBaseFontElement = objcclass external;
  DOMHTMLBodyElement = objcclass external;
  DOMHTMLButtonElement = objcclass external;
  DOMHTMLCollection = objcclass external;
  DOMHTMLDListElement = objcclass external;
  DOMHTMLDirectoryElement = objcclass external;
  DOMHTMLDivElement = objcclass external;
  DOMHTMLDocument = objcclass external;
  DOMHTMLElement = objcclass external;
  DOMHTMLEmbedElement = objcclass external;
  DOMHTMLFieldSetElement = objcclass external;
  DOMHTMLFontElement = objcclass external;
  DOMHTMLFormElement = objcclass external;
  DOMHTMLFrameElement = objcclass external;
  DOMHTMLFrameSetElement = objcclass external;
  DOMHTMLHRElement = objcclass external;
  DOMHTMLHeadElement = objcclass external;
  DOMHTMLHeadingElement = objcclass external;
  DOMHTMLHtmlElement = objcclass external;
  DOMHTMLIFrameElement = objcclass external;
  DOMHTMLImageElement = objcclass external;
  DOMHTMLInputElement = objcclass external;
  DOMHTMLLIElement = objcclass external;
  DOMHTMLLabelElement = objcclass external;
  DOMHTMLLegendElement = objcclass external;
  DOMHTMLLinkElement = objcclass external;
  DOMHTMLMapElement = objcclass external;
  DOMHTMLMarqueeElement = objcclass external;
  DOMHTMLMenuElement = objcclass external;
  DOMHTMLMetaElement = objcclass external;
  DOMHTMLModElement = objcclass external;
  DOMHTMLOListElement = objcclass external;
  DOMHTMLObjectElement = objcclass external;
  DOMHTMLOptGroupElement = objcclass external;
  DOMHTMLOptionElement = objcclass external;
  DOMHTMLOptionsCollection = objcclass external;
  DOMHTMLParagraphElement = objcclass external;
  DOMHTMLParamElement = objcclass external;
  DOMHTMLPreElement = objcclass external;
  DOMHTMLQuoteElement = objcclass external;
  DOMHTMLScriptElement = objcclass external;
  DOMHTMLSelectElement = objcclass external;
  DOMHTMLStyleElement = objcclass external;
  DOMHTMLTableCaptionElement = objcclass external;
  DOMHTMLTableCellElement = objcclass external;
  DOMHTMLTableColElement = objcclass external;
  DOMHTMLTableElement = objcclass external;
  DOMHTMLTableRowElement = objcclass external;
  DOMHTMLTableSectionElement = objcclass external;
  DOMHTMLTextAreaElement = objcclass external;
  DOMHTMLTitleElement = objcclass external;
  DOMHTMLUListElement = objcclass external;
  DOMImplementation = objcclass external;
  DOMKeyboardEvent = objcclass external;
  DOMMediaList = objcclass external;
  DOMMouseEvent = objcclass external;
  DOMMutationEvent = objcclass external;
  DOMNamedNodeMap = objcclass external;
  DOMNode = objcclass external;
  DOMNodeIterator = objcclass external;
  DOMNodeList = objcclass external;
  DOMNotation = objcclass external;
  DOMObject = objcclass external;
  DOMOverflowEvent = objcclass external;
  DOMProcessingInstruction = objcclass external;
  DOMProgressEvent = objcclass external;
  DOMRGBColor = objcclass external;
  DOMRange = objcclass external;
  DOMRect = objcclass external;
  DOMStyleSheet = objcclass external;
  DOMStyleSheetList = objcclass external;
  DOMText = objcclass external;
  DOMTreeWalker = objcclass external;
  DOMUIEvent = objcclass external;
  DOMWheelEvent = objcclass external;
  DOMXPathExpression = objcclass external;
  DOMXPathResult = objcclass external;
  WKBackForwardList = objcclass external;
  WKBackForwardListItem = objcclass external;
  WKFrameInfo = objcclass external;
  WKNavigation = objcclass external;
  WKNavigationAction = objcclass external;
  WKNavigationResponse = objcclass external;
  WKPreferences = objcclass external;
  WKProcessPool = objcclass external;
  WKScriptMessage = objcclass external;
  WKUserContentController = objcclass external;
  WKUserScript = objcclass external;
  WKWebView = objcclass external;
  WKWebViewConfiguration = objcclass external;
  WKWindowFeatures = objcclass external;
  WebArchive = objcclass external;
  WebBackForwardList = objcclass external;
  WebDataSource = objcclass external;
  WebDownload = objcclass external;
  WebFrame = objcclass external;
  WebFrameView = objcclass external;
  WebHistory = objcclass external;
  WebHistoryItem = objcclass external;
  WebPreferences = objcclass external;
  WebResource = objcclass external;
  WebScriptObject = objcclass external;
  WebUndefined = objcclass external;
  WebView = objcclass external;
  DOMEventListenerProtocol = objcprotocol external name 'DOMEventListener';
  DOMEventTargetProtocol = objcprotocol external name 'DOMEventTarget';
  DOMNodeFilterProtocol = objcprotocol external name 'DOMNodeFilter';
  DOMXPathNSResolverProtocol = objcprotocol external name 'DOMXPathNSResolver';
  WKNavigationDelegateProtocol = objcprotocol external name 'WKNavigationDelegate';
  WKScriptMessageHandlerProtocol = objcprotocol external name 'WKScriptMessageHandler';
  WKUIDelegateProtocol = objcprotocol external name 'WKUIDelegate';
  WebDocumentRepresentationProtocol = objcprotocol external name 'WebDocumentRepresentation';
  WebDocumentSearchingProtocol = objcprotocol external name 'WebDocumentSearching';
  WebDocumentTextProtocol = objcprotocol external name 'WebDocumentText';
  WebDocumentViewProtocol = objcprotocol external name 'WebDocumentView';
  WebOpenPanelResultListenerProtocol = objcprotocol external name 'WebOpenPanelResultListener';
  WebPlugInViewFactoryProtocol = objcprotocol external name 'WebPlugInViewFactory';
  WebPolicyDecisionListenerProtocol = objcprotocol external name 'WebPolicyDecisionListener';

type
  JSContext = objcclass external;
  JSValue = objcclass external;
  NSArray = objcclass external;
  NSColor = objcclass external;
  NSError = objcclass external;
  NSImage = objcclass external;
  NSMutableURLRequest = objcclass external;
  NSString = objcclass external;
  NSURL = objcclass external;
  NSURLAuthenticationChallenge = objcclass external;
  NSURLConnection = objcclass external;
  NSURLRequest = objcclass external;
  NSURLResponse = objcclass external;
  WebArchivePrivate = objcclass external;
  WebBackForwardListPrivate = objcclass external;
  WebDownloadInternal = objcclass external;
  WebFramePrivate = objcclass external;
  WebFrameViewPrivate = objcclass external;
  WebHistoryItemPrivate = objcclass external;
  WebHistoryPrivate = objcclass external;
  WebPolicyPrivate = objcclass external;
  WebResourcePrivate = objcclass external;
  WebScriptObjectPrivate = objcclass external;
  WebViewPrivate = objcclass external;

implementation
end.
