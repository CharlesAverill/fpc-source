Name: fpc
Version: 1.1
Release: 0
ExclusiveArch: i386 i586 i686
Copyright: GPL
Group: Development/Languages
Source: %{name}-%{version}-src.tar.gz
Summary: Free Pascal Compiler
Packager: Peter Vreman (peter@freepascal.org)
URL: http://www.freepascal.org/
BuildRoot: %{_tmppath}/fpc-build
BuildRequires: fpc

%define fpcdir %{_libdir}/fpc/%{version}
%define docdir %{_docdir}/fpc-%{version}
%define exampledir %{docdir}/examples

%define builddocdir %{buildroot}%{docdir}
%define buildmandir %{buildroot}%{_mandir}
%define buildbindir %{buildroot}%{_bindir}
%define buildlibdir %{buildroot}%{_libdir}
%define buildexampledir %{buildroot}%{exampledir}

# The normal redhat rpm scripts does not recognize properly, what files to strip
# Hook our own strip command
%define __strip %{buildroot}/smart_strip.sh


%description
The Free Pascal Compiler is a Turbo Pascal 7.0 and Delphi compatible 32bit
Pascal Compiler. It comes with fully TP 7.0 compatible run-time library.
Some extensions are added to the language, like function overloading. Shared
libraries can be linked. Basic Delphi support is already implemented (classes,
exceptions,ansistrings,RTTI). This package contains commandline compiler and
utils. Provided units are the runtime library (RTL), free component library
(FCL), gtk,ncurses,zlib, mysql,postgres,ibase bindings.

###############################################################################
# fpc.rpm
#

%prep
%setup -c

%build
NEWPP=`pwd`/compiler/ppc386
NEWFPDOC=`pwd`/utils/fpdoc/fpdoc
	make compiler_cycle
	make rtl_clean rtl_smart FPC=${NEWPP}
	make packages_base_smart FPC=${NEWPP}
	make fcl_smart FPC=${NEWPP}
	make packages_extra_smart FPC=${NEWPP}
	make utils_all FPC=${NEWPP}
if [ -z ${NODOCS} ]; then
	make -C docs pdf FPDOC=${NEWFPDOC}
fi

%install
if [ %{buildroot} != "/" ]; then
	rm -rf %{buildroot}
fi

NEWPP=`pwd`/compiler/ppc386
INSTALLOPTS="FPC=${NEWPP} INSTALL_PREFIX=%{buildroot}/usr INSTALL_LIBDIR=%{buildlibdir} \
		INSTALL_DOCDIR=%{builddocdir} INSTALL_BINDIR=%{buildbindir}"
	make compiler_distinstall ${INSTALLOPTS}
	make rtl_distinstall ${INSTALLOPTS}
	make packages_distinstall ${INSTALLOPTS}
	make fcl_distinstall ${INSTALLOPTS}
	make utils_distinstall ${INSTALLOPTS}

	make demo_install ${INSTALLOPTS} INSTALL_SOURCEDIR=%{buildexampledir}
	make doc_install ${INSTALLOPTS}
	make man_install ${INSTALLOPTS} INSTALL_PREFIX=%{buildmandir}
	
if [ -z ${NODOCS} ]; then
	make -C docs pdfinstall DOCINSTALLDIR=%{builddocdir}
fi

	# create link
	ln -sf %{fpcdir}/ppc386 %{buildroot}%{_bindir}/ppc386

        # Workaround:
        # newer rpm versions do not allow garbage
        # delete lexyacc
        rm -rf %{buildroot}/usr/lib/fpc/lexyacc


%clean
	make compiler_clean
	make rtl_clean
	make packages_clean
	make fcl_clean
	make utils_clean
	make -C docs clean

if [ %{buildroot} != "/" ]; then
	rm -rf %{buildroot}
fi

%post
# Create a version independent config
%{fpcdir}/samplecfg %{_libdir}/fpc/\$version

%files
%defattr(-, root, root)
%{_bindir}/*
%{fpcdir}
%doc %{docdir}/NEWS
%doc %{docdir}/README
%doc %{docdir}/faq*
%doc %{exampledir}/*
%{_mandir}/*/*
