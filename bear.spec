
Name:              bear
Version:           %{bear_version}
Release:           1.itl
Summary:           tool that generates a compilation database for clang tooling
License:           GPL
Source0:           Bear-%{bear_version}.tar.gz
Source1:           cvimfiles

%description
tool that generates a compilation database for clang tooling

%prep
%setup -q -n Bear-%{version}

%build
cmake .
make COLOR=0

%install
make COLOR=0 install INSTALL="install -p" DESTDIR=%{buildroot}
install %{S:1} %{buildroot}/usr/local/bin

%files
%attr(755, root, root) %{_exec_prefix}/local/bin/*
%{_exec_prefix}/local/%{_lib}/*
%{_prefix}/local/share/*
%{_prefix}/local/share/doc/%{name}/*

%changelog
* Fri Jun 1 2018 Marco Angaroni <marcoangaroni@gmail.com> - 2.3.11-1.itl
- First version

