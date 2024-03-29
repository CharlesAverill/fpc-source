{$mode macpas}
{$packenum 1}
{$macro on}
{$inline on}
{$CALLING MWPASCAL}

{$IFNDEF FPC_DOTTEDUNITS}
unit MacOS;
{$ENDIF FPC_DOTTEDUNITS}
interface

{$IFDEF FPC_DOTTEDUNITS}
uses 
  MacOsApi.ABActions,
  MacOsApi.ABAddressBook,
  MacOsApi.ABGlobals,
  MacOsApi.ABPeoplePicker,
  MacOsApi.ABTypedefs,
  MacOsApi.AEDataModel,
  MacOsApi.AEHelpers,
  MacOsApi.AEInteraction,
  MacOsApi.AEMach,
  MacOsApi.AEObjects,
  MacOsApi.AEPackObject,
  MacOsApi.AERegistry,
  MacOsApi.AEUserTermTypes,
  MacOsApi.AIFF,
  MacOsApi.ASDebugging,
  MacOsApi.ASRegistry,
  MacOsApi.ATSFont,
  MacOsApi.ATSLayoutTypes,
  MacOsApi.ATSTypes,
  MacOsApi.ATSUnicodeDirectAccess,
  MacOsApi.ATSUnicodeDrawing,
  MacOsApi.ATSUnicodeFlattening,
  MacOsApi.ATSUnicodeFonts,
  MacOsApi.ATSUnicodeGlyphs,
  MacOsApi.ATSUnicodeObjects,
  MacOsApi.ATSUnicodeTypes,
  MacOsApi.AUComponent,
  MacOsApi.AVLTree,
  MacOsApi.AXActionConstants,
  MacOsApi.AXAttributeConstants,
  MacOsApi.AXConstants,
  MacOsApi.AXErrors,
  MacOsApi.AXNotificationConstants,
  MacOsApi.AXRoleConstants,
  MacOsApi.AXTextAttributedString,
  MacOsApi.AXUIElement,
  MacOsApi.AXValue,
  MacOsApi.AXValueConstants,
  MacOsApi.Accessibility,
  MacOsApi.Aliases,
  MacOsApi.Appearance,
  MacOsApi.AppleDiskPartitions,
  MacOsApi.AppleEvents,
  MacOsApi.AppleHelp,
  MacOsApi.AppleScript,
  MacOsApi.AudioCodecs,
  MacOsApi.AudioComponents,
  MacOsApi.AudioConverter,
  MacOsApi.AudioFile,
  MacOsApi.AudioFileComponents,
  MacOsApi.AudioFileStream,
  MacOsApi.AudioFormat,
  MacOsApi.AudioHardware,
  MacOsApi.AudioHardwareBase,
  MacOsApi.AudioHardwareDeprecated,
  MacOsApi.AudioHardwareService,
  MacOsApi.AudioOutputUnit,
  MacOsApi.AudioQueue,
  MacOsApi.AudioServices,
  MacOsApi.AudioUnitCarbonViews,
  MacOsApi.AudioUnitParameters,
  MacOsApi.AudioUnitProperties,
  MacOsApi.AudioUnitUtilities,
  MacOsApi.AuthSession,
  MacOsApi.Authorization,
  MacOsApi.AuthorizationDB,
  MacOsApi.AuthorizationPlugin,
  MacOsApi.AuthorizationTags,
  MacOsApi.BackupCore,
  MacOsApi.CFArray,
  MacOsApi.CFAttributedString,
  MacOsApi.CFBag,
  MacOsApi.CFBase,
  MacOsApi.CFBinaryHeap,
  MacOsApi.CFBitVector,
  MacOsApi.CFBundle,
  MacOsApi.CFByteOrders,
  MacOsApi.CFCalendar,
  MacOsApi.CFCharacterSet,
  MacOsApi.CFData,
  MacOsApi.CFDate,
  MacOsApi.CFDateFormatter,
  MacOsApi.CFDictionary,
  MacOsApi.CFError,
  MacOsApi.CFFTPStream,
  MacOsApi.CFFileDescriptor,
  MacOsApi.CFFileSecurity,
  MacOsApi.CFHTTPAuthentication,
  MacOsApi.CFHTTPMessage,
  MacOsApi.CFHTTPStream,
  MacOsApi.CFHost,
  MacOsApi.CFLocale,
  MacOsApi.CFMachPort,
  MacOsApi.CFMessagePort,
  MacOsApi.CFNetDiagnostics,
  MacOsApi.CFNetServices,
  MacOsApi.CFNetworkErrorss,
  MacOsApi.CFNotificationCenter,
  MacOsApi.CFNumber,
  MacOsApi.CFNumberFormatter,
  MacOsApi.CFPlugIn,
  MacOsApi.CFPlugInCOM,
  MacOsApi.CFPreferences,
  MacOsApi.CFPropertyList,
  MacOsApi.CFProxySupport,
  MacOsApi.CFRunLoop,
  MacOsApi.CFSet,
  MacOsApi.CFSocket,
  MacOsApi.CFSocketStream,
  MacOsApi.CFStream,
  MacOsApi.CFString,
  MacOsApi.CFStringEncodingExt,
  MacOsApi.CFStringTokenizer,
  MacOsApi.CFTimeZone,
  MacOsApi.CFTree,
  MacOsApi.CFURL,
  MacOsApi.CFURLAccess,
  MacOsApi.CFURLEnumerator,
  MacOsApi.CFUUID,
  MacOsApi.CFUserNotification,
  MacOsApi.CFXMLNode,
  MacOsApi.CFXMLParser,
  MacOsApi.CGAffineTransforms,
  MacOsApi.CGBase,
  MacOsApi.CGBitmapContext,
  MacOsApi.CGColor,
  MacOsApi.CGColorSpace,
  MacOsApi.CGContext,
  MacOsApi.CGDataConsumer,
  MacOsApi.CGDataProvider,
  MacOsApi.CGDirectDisplay,
  MacOsApi.CGDirectPalette,
  MacOsApi.CGDisplayConfiguration,
  MacOsApi.CGDisplayFades,
  MacOsApi.CGErrors,
  MacOsApi.CGEvent,
  MacOsApi.CGEventSource,
  MacOsApi.CGEventTypes,
  MacOsApi.CGFont,
  MacOsApi.CGFunction,
  MacOsApi.CGGLContext,
  MacOsApi.CGGeometry,
  MacOsApi.CGGradient,
  MacOsApi.CGImage,
  MacOsApi.CGImageDestination,
  MacOsApi.CGImageMetadata,
  MacOsApi.CGImageProperties,
  MacOsApi.CGImageSource,
  MacOsApi.CGLCurrent,
  MacOsApi.CGLDevice,
  MacOsApi.CGLProfiler,
  MacOsApi.CGLProfilerFunctionEnums,
  MacOsApi.CGLRenderers,
  MacOsApi.CGLTypes,
  MacOsApi.CGLayer,
  MacOsApi.CGPDFArray,
  MacOsApi.CGPDFContentStream,
  MacOsApi.CGPDFContext,
  MacOsApi.CGPDFDictionary,
  MacOsApi.CGPDFDocument,
  MacOsApi.CGPDFObject,
  MacOsApi.CGPDFOperatorTable,
  MacOsApi.CGPDFPage,
  MacOsApi.CGPDFScanner,
  MacOsApi.CGPDFStream,
  MacOsApi.CGPDFString,
  MacOsApi.CGPSConverter,
  MacOsApi.CGPath,
  MacOsApi.CGPattern,
  MacOsApi.CGRemoteOperation,
  MacOsApi.CGSession,
  MacOsApi.CGShading,
  MacOsApi.CGWindow,
  MacOsApi.CGWindowLevels,
  MacOsApi.CMCalibrator,
  MacOsApi.CSIdentity,
  MacOsApi.CSIdentityAuthority,
  MacOsApi.CSIdentityBase,
  MacOsApi.CSIdentityQuery,
  MacOsApi.CTFont,
  MacOsApi.CTFontCollection,
  MacOsApi.CTFontDescriptor,
  MacOsApi.CTFontManager,
  MacOsApi.CTFontManagerErrors,
  MacOsApi.CTFontTraits,
  MacOsApi.CTFrame,
  MacOsApi.CTFramesetter,
  MacOsApi.CTGlyphInfo,
  MacOsApi.CTLine,
  MacOsApi.CTParagraphStyle,
  MacOsApi.CTRun,
  MacOsApi.CTStringAttributes,
  MacOsApi.CTTextTab,
  MacOsApi.CTTypesetter,
  MacOsApi.CVBase,
  MacOsApi.CVBuffer,
  MacOsApi.CVDisplayLink,
  MacOsApi.CVHostTime,
  MacOsApi.CVImageBuffer,
  MacOsApi.CVOpenGLBuffer,
  MacOsApi.CVOpenGLBufferPool,
  MacOsApi.CVOpenGLTexture,
  MacOsApi.CVOpenGLTextureCache,
  MacOsApi.CVPixelBuffer,
  MacOsApi.CVPixelBufferIOSurface,
  MacOsApi.CVPixelBufferPool,
  MacOsApi.CVPixelFormatDescription,
  MacOsApi.CVReturns,
  MacOsApi.CaptiveNetwork,
  MacOsApi.CarbonEvents,
  MacOsApi.CarbonEventsCore,
  MacOsApi.CodeFragments,
  MacOsApi.Collections,
  MacOsApi.ColorPicker,
  MacOsApi.ColorSyncCMM,
  MacOsApi.ColorSyncDeprecated,
  MacOsApi.ColorSyncDevice,
  MacOsApi.ColorSyncProfile,
  MacOsApi.ColorSyncTransform,
  MacOsApi.Components,
  MacOsApi.ConditionalMacros,
  MacOsApi.ControlDefinitions,
  MacOsApi.Controls,
  MacOsApi.CoreAudioTypes,
  MacOsApi.CoreFoundation,
  MacOsApi.CoreGraphics,
  MacOsApi.CoreText,
  MacOsApi.DADisk,
  MacOsApi.DASession,
  MacOsApi.DHCPClientPreferences,
  MacOsApi.DateTimeUtils,
  MacOsApi.Debugging,
  MacOsApi.Dialogs,
  MacOsApi.Dictionary,
  MacOsApi.DictionaryServices,
  MacOsApi.DigitalHubRegistry,
  MacOsApi.Displays,
  MacOsApi.Drag,
  MacOsApi.DrawSprocket,
  MacOsApi.DriverServices,
  MacOsApi.DriverSynchronization,
  MacOsApi.Endian,
  MacOsApi.Events,
  MacOsApi.FSEvents,
  MacOsApi.FileTypesAndCreators,
  MacOsApi.Files,
  MacOsApi.Finder,
  MacOsApi.FinderRegistry,
  MacOsApi.FixMath,
  MacOsApi.Folders,
  MacOsApi.FontPanel,
  MacOsApi.FontSync,
  MacOsApi.Fonts,
  MacOsApi.GestaltEqu,
  MacOsApi.HFSVolumes,
  MacOsApi.HIAccessibility,
  MacOsApi.HIArchive,
  MacOsApi.HIButtonViews,
  MacOsApi.HIClockView,
  MacOsApi.HIComboBox,
  MacOsApi.HIContainerViews,
  MacOsApi.HIDataBrowser,
  MacOsApi.HIDisclosureViews,
  MacOsApi.HIGeometry,
  MacOsApi.HIImageViews,
  MacOsApi.HILittleArrows,
  MacOsApi.HIMenuView,
  MacOsApi.HIMovieView,
  MacOsApi.HIObject,
  MacOsApi.HIPopupButton,
  MacOsApi.HIProgressViews,
  MacOsApi.HIRelevanceBar,
  MacOsApi.HIScrollView,
  MacOsApi.HISearchField,
  MacOsApi.HISegmentedView,
  MacOsApi.HISeparator,
  MacOsApi.HIShape,
  MacOsApi.HISlider,
  MacOsApi.HITabbedView,
  MacOsApi.HITextLengthFilter,
  MacOsApi.HITextUtils,
  MacOsApi.HITextViews,
  MacOsApi.HITheme,
  MacOsApi.HIToolbar,
  MacOsApi.HIToolbox,
  MacOsApi.HIToolboxDebugging,
  MacOsApi.HIView,
  MacOsApi.HIWindowViews,
  MacOsApi.HTMLRendering,
  MacOsApi.HostTime,
  MacOsApi.IBCarbonRuntime,
  MacOsApi.ICAApplication,
  MacOsApi.ICACamera,
  MacOsApi.ICADevice,
  MacOsApi.IOKitReturn,
  MacOsApi.IOSurfaceAPI,
  MacOsApi.IconStorage,
  MacOsApi.Icons,
  MacOsApi.IconsCore,
  MacOsApi.ImageCodec,
  MacOsApi.ImageCompression,
  MacOsApi.InternetConfig,
  MacOsApi.IntlResources,
  MacOsApi.Keyboards,
  MacOsApi.KeychainCore,
  MacOsApi.KeychainHI,
  MacOsApi.LSInfo,
  MacOsApi.LSOpen,
  MacOsApi.LSQuarantine,
  MacOsApi.LSSharedFileList,
  MacOsApi.LanguageAnalysis,
  MacOsApi.Lists,
  MacOsApi.LowMem,
  MacOsApi.MDExternalDatastore,
  MacOsApi.MDImporter,
  MacOsApi.MDItem,
  MacOsApi.MDLineage,
  MacOsApi.MDQuery,
  MacOsApi.MDSchema,
  MacOsApi.MIDIDriver,
  MacOsApi.MIDIServices,
  MacOsApi.MIDISetup,
  MacOsApi.MIDIThruConnection,
  MacOsApi.MacApplication,
  MacOsApi.MacErrors,
  MacOsApi.MacHelp,
  MacOsApi.MacLocales,
  MacOsApi.MacMemory,
  MacOsApi.MacOSXPosix,
  MacOsApi.MacOpenGL,
  MacOsApi.MacTextEditor,
  MacOsApi.MacTypes,
  MacOsApi.MacWindows,
  MacOsApi.MachineExceptions,
  MacOsApi.Math64,
  MacOsApi.MediaHandlers,
  MacOsApi.Menus,
  MacOsApi.MixedMode,
  MacOsApi.Movies,
  MacOsApi.MoviesFormat,
  MacOsApi.MultiProcessingInfo,
  MacOsApi.Multiprocessing,
  MacOsApi.MusicDevice,
  MacOsApi.NSL,
  MacOsApi.NSLCore,
  MacOsApi.Navigation,
  MacOsApi.Notification,
  MacOsApi.NumberFormatting,
  MacOsApi.OSA,
  MacOsApi.OSAComp,
  MacOsApi.OSAGeneric,
  MacOsApi.OSUtils,
  MacOsApi.ObjCRuntime,
  MacOsApi.OpenTransport,
  MacOsApi.OpenTransportProtocol,
  MacOsApi.OpenTransportProviders,
  MacOsApi.PEFBinaryFormat,
  MacOsApi.PLStringFuncs,
  MacOsApi.PMApplication,
  MacOsApi.PMApplicationDeprecated,
  MacOsApi.PMCore,
  MacOsApi.PMCoreDeprecated,
  MacOsApi.PMDefinitions,
  MacOsApi.PMDefinitionsDeprecated,
  MacOsApi.PMErrors,
  MacOsApi.PMPrintAETypes,
  MacOsApi.PMPrintSettingsKeys,
  MacOsApi.PMPrintingDialogExtensions,
  MacOsApi.Palettes,
  MacOsApi.Pasteboard,
  MacOsApi.PictUtils,
  MacOsApi.Power,
  MacOsApi.Processes,
  MacOsApi.QDCMCommon,
  MacOsApi.QDOffscreen,
  MacOsApi.QDPictToCGContext,
  MacOsApi.QLBase,
  MacOsApi.QLGenerator,
  MacOsApi.QLThumbnail,
  MacOsApi.QLThumbnailImage,
  MacOsApi.QTML,
  MacOsApi.QTSMovie,
  MacOsApi.QTStreamingComponents,
  MacOsApi.QuickTimeComponents,
  MacOsApi.QuickTimeErrors,
  MacOsApi.QuickTimeMusic,
  MacOsApi.QuickTimeStreaming,
  MacOsApi.QuickTimeVR,
  MacOsApi.QuickTimeVRFormat,
  MacOsApi.Quickdraw,
  MacOsApi.QuickdrawText,
  MacOsApi.QuickdrawTypes,
  MacOsApi.Resources,
  MacOsApi.SCDynamicStore,
  MacOsApi.SCDynamicStoreCopyDHCPInfos,
  MacOsApi.SCDynamicStoreCopySpecific,
  MacOsApi.SCDynamicStoreKey,
  MacOsApi.SCNetwork,
  MacOsApi.SCNetworkConfiguration,
  MacOsApi.SCNetworkConnection,
  MacOsApi.SCNetworkReachability,
  MacOsApi.SCPreferences,
  MacOsApi.SCPreferencesPath,
  MacOsApi.SCPreferencesSetSpecific,
  MacOsApi.SCSI,
  MacOsApi.SCSchemaDefinitions,
  MacOsApi.SFNTLayoutTypes,
  MacOsApi.SFNTTypes,
  MacOsApi.SKAnalysis,
  MacOsApi.SKDocument,
  MacOsApi.SKIndex,
  MacOsApi.SKSearch,
  MacOsApi.SKSummary,
  MacOsApi.ScalerStreamTypes,
  MacOsApi.Scrap,
  MacOsApi.Script,
  MacOsApi.SecBase,
  MacOsApi.SecTrust,
  MacOsApi.Sound,
  MacOsApi.SpeechRecognition,
  MacOsApi.SpeechSynthesis,
  MacOsApi.StringCompare,
  MacOsApi.SystemConfiguration,
  MacOsApi.SystemSound,
  MacOsApi.TSMTE,
  MacOsApi.TextCommon,
  MacOsApi.TextEdit,
  MacOsApi.TextEncodingConverter,
  MacOsApi.TextEncodingPlugin,
  MacOsApi.TextInputSources,
  MacOsApi.TextServices,
  MacOsApi.TextUtils,
  MacOsApi.Threads,
  MacOsApi.Timer,
  MacOsApi.ToolUtils,
  MacOsApi.Translation,
  MacOsApi.TranslationExtensions,
  MacOsApi.TranslationServices,
  MacOsApi.TypeSelect,
  MacOsApi.URLAccess,
  MacOsApi.UTCUtils,
  MacOsApi.UTCoreTypes,
  MacOsApi.UTType,
  MacOsApi.UnicodeConverter,
  MacOsApi.UnicodeUtilities,
  MacOsApi.UniversalAccess,
  MacOsApi.Video,
  MacOsApi.WSMethodInvocation,
  MacOsApi.WSProtocolHandler,
  MacOsApi.WSTypes,
  MacOsApi.Acl,
  MacOsApi.Cblas,
  MacOsApi.Certextensions,
  MacOsApi.Cssmapple,
  MacOsApi.Cssmconfig,
  MacOsApi.Cssmerr,
  MacOsApi.Cssmkrapi,
  MacOsApi.Cssmtype,
  MacOsApi.Fenv,
  MacOsApi.Fp,
  MacOsApi.GliContexts,
  MacOsApi.GliDispatch,
  MacOsApi.GluContext,
  MacOsApi.Kern_return,
  MacOsApi.Macgl,
  MacOsApi.Macglext,
  MacOsApi.Macglu,
  MacOsApi.Mach_error,
  MacOsApi.VBLAS,
  MacOsApi.VDSP,
  MacOsApi.X509defs,
  MacOsApi.Xattr,
  MacOsApi.GPCStrings;
{$ELSE FPC_DOTTEDUNITS}
uses 
  ABActions,
  ABAddressBook,
  ABGlobals,
  ABPeoplePicker,
  ABTypedefs,
  AEDataModel,
  AEHelpers,
  AEInteraction,
  AEMach,
  AEObjects,
  AEPackObject,
  AERegistry,
  AEUserTermTypes,
  AIFF,
  ASDebugging,
  ASRegistry,
  ATSFont,
  ATSLayoutTypes,
  ATSTypes,
  ATSUnicodeDirectAccess,
  ATSUnicodeDrawing,
  ATSUnicodeFlattening,
  ATSUnicodeFonts,
  ATSUnicodeGlyphs,
  ATSUnicodeObjects,
  ATSUnicodeTypes,
  AUComponent,
  AVLTree,
  AXActionConstants,
  AXAttributeConstants,
  AXConstants,
  AXErrors,
  AXNotificationConstants,
  AXRoleConstants,
  AXTextAttributedString,
  AXUIElement,
  AXValue,
  AXValueConstants,
  Accessibility,
  Aliases,
  Appearance,
  AppleDiskPartitions,
  AppleEvents,
  AppleHelp,
  AppleScript,
  AudioCodecs,
  AudioComponents,
  AudioConverter,
  AudioFile,
  AudioFileComponents,
  AudioFileStream,
  AudioFormat,
  AudioHardware,
  AudioHardwareBase,
  AudioHardwareDeprecated,
  AudioHardwareService,
  AudioOutputUnit,
  AudioQueue,
  AudioServices,
  AudioUnitCarbonViews,
  AudioUnitParameters,
  AudioUnitProperties,
  AudioUnitUtilities,
  AuthSession,
  Authorization,
  AuthorizationDB,
  AuthorizationPlugin,
  AuthorizationTags,
  BackupCore,
  CFArray,
  CFAttributedString,
  CFBag,
  CFBase,
  CFBinaryHeap,
  CFBitVector,
  CFBundle,
  CFByteOrders,
  CFCalendar,
  CFCharacterSet,
  CFData,
  CFDate,
  CFDateFormatter,
  CFDictionary,
  CFError,
  CFFTPStream,
  CFFileDescriptor,
  CFFileSecurity,
  CFHTTPAuthentication,
  CFHTTPMessage,
  CFHTTPStream,
  CFHost,
  CFLocale,
  CFMachPort,
  CFMessagePort,
  CFNetDiagnostics,
  CFNetServices,
  CFNetworkErrorss,
  CFNotificationCenter,
  CFNumber,
  CFNumberFormatter,
  CFPlugIn,
  CFPlugInCOM,
  CFPreferences,
  CFPropertyList,
  CFProxySupport,
  CFRunLoop,
  CFSet,
  CFSocket,
  CFSocketStream,
  CFStream,
  CFString,
  CFStringEncodingExt,
  CFStringTokenizer,
  CFTimeZone,
  CFTree,
  CFURL,
  CFURLAccess,
  CFURLEnumerator,
  CFUUID,
  CFUserNotification,
  CFXMLNode,
  CFXMLParser,
  CGAffineTransforms,
  CGBase,
  CGBitmapContext,
  CGColor,
  CGColorSpace,
  CGContext,
  CGDataConsumer,
  CGDataProvider,
  CGDirectDisplay,
  CGDirectPalette,
  CGDisplayConfiguration,
  CGDisplayFades,
  CGErrors,
  CGEvent,
  CGEventSource,
  CGEventTypes,
  CGFont,
  CGFunction,
  CGGLContext,
  CGGeometry,
  CGGradient,
  CGImage,
  CGImageDestination,
  CGImageMetadata,
  CGImageProperties,
  CGImageSource,
  CGLCurrent,
  CGLDevice,
  CGLProfiler,
  CGLProfilerFunctionEnums,
  CGLRenderers,
  CGLTypes,
  CGLayer,
  CGPDFArray,
  CGPDFContentStream,
  CGPDFContext,
  CGPDFDictionary,
  CGPDFDocument,
  CGPDFObject,
  CGPDFOperatorTable,
  CGPDFPage,
  CGPDFScanner,
  CGPDFStream,
  CGPDFString,
  CGPSConverter,
  CGPath,
  CGPattern,
  CGRemoteOperation,
  CGSession,
  CGShading,
  CGWindow,
  CGWindowLevels,
  CMCalibrator,
  CSIdentity,
  CSIdentityAuthority,
  CSIdentityBase,
  CSIdentityQuery,
  CTFont,
  CTFontCollection,
  CTFontDescriptor,
  CTFontManager,
  CTFontManagerErrors,
  CTFontTraits,
  CTFrame,
  CTFramesetter,
  CTGlyphInfo,
  CTLine,
  CTParagraphStyle,
  CTRun,
  CTStringAttributes,
  CTTextTab,
  CTTypesetter,
  CVBase,
  CVBuffer,
  CVDisplayLink,
  CVHostTime,
  CVImageBuffer,
  CVOpenGLBuffer,
  CVOpenGLBufferPool,
  CVOpenGLTexture,
  CVOpenGLTextureCache,
  CVPixelBuffer,
  CVPixelBufferIOSurface,
  CVPixelBufferPool,
  CVPixelFormatDescription,
  CVReturns,
  CaptiveNetwork,
  CarbonEvents,
  CarbonEventsCore,
  CodeFragments,
  Collections,
  ColorPicker,
  ColorSyncCMM,
  ColorSyncDeprecated,
  ColorSyncDevice,
  ColorSyncProfile,
  ColorSyncTransform,
  Components,
  ConditionalMacros,
  ControlDefinitions,
  Controls,
  CoreAudioTypes,
  CoreFoundation,
  CoreGraphics,
  CoreText,
  DADisk,
  DASession,
  DHCPClientPreferences,
  DateTimeUtils,
  Debugging,
  Dialogs,
  Dictionary,
  DictionaryServices,
  DigitalHubRegistry,
  Displays,
  Drag,
  DrawSprocket,
  DriverServices,
  DriverSynchronization,
  Endian,
  Events,
  FSEvents,
  FileTypesAndCreators,
  Files,
  Finder,
  FinderRegistry,
  FixMath,
  Folders,
  FontPanel,
  FontSync,
  Fonts,
  GestaltEqu,
  HFSVolumes,
  HIAccessibility,
  HIArchive,
  HIButtonViews,
  HIClockView,
  HIComboBox,
  HIContainerViews,
  HIDataBrowser,
  HIDisclosureViews,
  HIGeometry,
  HIImageViews,
  HILittleArrows,
  HIMenuView,
  HIMovieView,
  HIObject,
  HIPopupButton,
  HIProgressViews,
  HIRelevanceBar,
  HIScrollView,
  HISearchField,
  HISegmentedView,
  HISeparator,
  HIShape,
  HISlider,
  HITabbedView,
  HITextLengthFilter,
  HITextUtils,
  HITextViews,
  HITheme,
  HIToolbar,
  HIToolbox,
  HIToolboxDebugging,
  HIView,
  HIWindowViews,
  HTMLRendering,
  HostTime,
  IBCarbonRuntime,
  ICAApplication,
  ICACamera,
  ICADevice,
  IOKitReturn,
  IOSurfaceAPI,
  IconStorage,
  Icons,
  IconsCore,
  ImageCodec,
  ImageCompression,
  InternetConfig,
  IntlResources,
  Keyboards,
  KeychainCore,
  KeychainHI,
  LSInfo,
  LSOpen,
  LSQuarantine,
  LSSharedFileList,
  LanguageAnalysis,
  Lists,
  LowMem,
  MDExternalDatastore,
  MDImporter,
  MDItem,
  MDLineage,
  MDQuery,
  MDSchema,
  MIDIDriver,
  MIDIServices,
  MIDISetup,
  MIDIThruConnection,
  MacApplication,
  MacErrors,
  MacHelp,
  MacLocales,
  MacMemory,
  MacOSXPosix,
  MacOpenGL,
  MacTextEditor,
  MacTypes,
  MacWindows,
  MachineExceptions,
  Math64,
  MediaHandlers,
  Menus,
  MixedMode,
  Movies,
  MoviesFormat,
  MultiProcessingInfo,
  Multiprocessing,
  MusicDevice,
  NSL,
  NSLCore,
  Navigation,
  Notification,
  NumberFormatting,
  OSA,
  OSAComp,
  OSAGeneric,
  OSUtils,
  ObjCRuntime,
  OpenTransport,
  OpenTransportProtocol,
  OpenTransportProviders,
  PEFBinaryFormat,
  PLStringFuncs,
  PMApplication,
  PMApplicationDeprecated,
  PMCore,
  PMCoreDeprecated,
  PMDefinitions,
  PMDefinitionsDeprecated,
  PMErrors,
  PMPrintAETypes,
  PMPrintSettingsKeys,
  PMPrintingDialogExtensions,
  Palettes,
  Pasteboard,
  PictUtils,
  Power,
  Processes,
  QDCMCommon,
  QDOffscreen,
  QDPictToCGContext,
  QLBase,
  QLGenerator,
  QLThumbnail,
  QLThumbnailImage,
  QTML,
  QTSMovie,
  QTStreamingComponents,
  QuickTimeComponents,
  QuickTimeErrors,
  QuickTimeMusic,
  QuickTimeStreaming,
  QuickTimeVR,
  QuickTimeVRFormat,
  Quickdraw,
  QuickdrawText,
  QuickdrawTypes,
  Resources,
  SCDynamicStore,
  SCDynamicStoreCopyDHCPInfos,
  SCDynamicStoreCopySpecific,
  SCDynamicStoreKey,
  SCNetwork,
  SCNetworkConfiguration,
  SCNetworkConnection,
  SCNetworkReachability,
  SCPreferences,
  SCPreferencesPath,
  SCPreferencesSetSpecific,
  SCSI,
  SCSchemaDefinitions,
  SFNTLayoutTypes,
  SFNTTypes,
  SKAnalysis,
  SKDocument,
  SKIndex,
  SKSearch,
  SKSummary,
  ScalerStreamTypes,
  Scrap,
  Script,
  SecBase,
  SecTrust,
  Sound,
  SpeechRecognition,
  SpeechSynthesis,
  StringCompare,
  SystemConfiguration,
  SystemSound,
  TSMTE,
  TextCommon,
  TextEdit,
  TextEncodingConverter,
  TextEncodingPlugin,
  TextInputSources,
  TextServices,
  TextUtils,
  Threads,
  Timer,
  ToolUtils,
  Translation,
  TranslationExtensions,
  TranslationServices,
  TypeSelect,
  URLAccess,
  UTCUtils,
  UTCoreTypes,
  UTType,
  UnicodeConverter,
  UnicodeUtilities,
  UniversalAccess,
  Video,
  WSMethodInvocation,
  WSProtocolHandler,
  WSTypes,
  acl,
  cblas,
  certextensions,
  cssmapple,
  cssmconfig,
  cssmerr,
  cssmkrapi,
  cssmtype,
  fenv,
  fp,
  gliContexts,
  gliDispatch,
  gluContext,
  kern_return,
  macgl,
  macglext,
  macglu,
  mach_error,
  vBLAS,
  vDSP,
  x509defs,
  xattr,
  GPCStrings;
{$ENDIF FPC_DOTTEDUNITS}

end.
