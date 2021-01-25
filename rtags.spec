
Name:              rtags
Version:           %{rtags_version}
Release:           1.itl
Summary:           A c/c++ client/server indexer based on clang
License:           GPL
Source0:           rtags-%{rtags_version}.tar.gz
Source1:           rct-%{rct_version}.tar.gz
Source2:           lua-%{lua_version}.tar.gz
Source3:           Selene-%{selene_version}.tar.gz
Source4:           %{name}.service
Source5:           %{name}.socket

BuildRequires:     clang-devel
BuildRequires:     llvm-devel
Requires:          clang
Requires:          llvm

BuildRequires:     systemd
Requires(post):    systemd
Requires(preun):   systemd
Requires(postun):  systemd

%description
A c/c++ client/server indexer based on clang

%prep
%setup -q
%setup -q -T -D -a 1 -c -n %{name}-%{version}/src/rct
%setup -q -T -D -a 2 -c -n %{name}-%{version}/src/lua
%setup -q -T -D -a 3 -c -n %{name}-%{version}/src/selene
cd %{_builddir}/%{name}-%{version}
mv src/rct/rct-%{rct_version}/* src/rct
rm -rf src/rct/rct-%{rct_version}
mv src/lua/lua-%{lua_version}/* src/lua
rm -rf src/lua/lua-%{lua_version}
mv src/selene/Selene-%{selene_version}/* src/selene
rm -rf src/selene/Selene-%{selene_version}

%build
cd %{_builddir}/%{name}-%{version}
cmake .
make COLOR=0

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service

%install
cd %{_builddir}/%{name}-%{version}
make install COLOR=0 INSTALL="install -p" DESTDIR=%{buildroot}
mkdir -p %{buildroot}%{_unitdir}
install -pm644 %{S:4} %{buildroot}%{_unitdir}
install -pm644 %{S:5} %{buildroot}%{_unitdir}

%files
%{_exec_prefix}/local/bin/*
%{_prefix}/local/share/bash-completion/completions
%{_prefix}/local/share/man/man7
%{_unitdir}/%{name}.service
%{_unitdir}/%{name}.socket

%changelog
* Fri Jun 1 2018 Marco Angaroni <marcoangaroni@gmail.com> - 2.18-1.itl
- First version

