#
# spec file for package mkosi-initrd-dracut
#
# Copyright (c) 2024 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#

Name:           mkosi-initrd-dracut
Version:        0.0.1
Release:        0
Summary:        dracut compatibility wrapper for mkosi-initrd
License:        GPL-2.0-or-later
Group:          System/Base
URL:            https://github.com/aafeijoo-suse/mkosi-initrd-dracut
Source0:        %{name}-%{version}.tar.xz
BuildRequires:  bash
Requires:       bash
Requires:       coreutils
Requires:       grep
Requires:       mkosi-initrd
Provides:       dracut = 666
Conflicts:      dracut

%description
dracut compatibility wrapper for mkosi-initrd.

%prep
%autosetup -p1

%install
install -D -m 0755 dracut.sh %{buildroot}%{_bindir}/dracut
mkdir -p %{buildroot}%{_prefix}/lib/mkosi-initrd-dracut
install -m 0755 dracut-lib.sh %{buildroot}%{_prefix}/lib/mkosi-initrd-dracut

%files
%{_bindir}/dracut
%dir %{_prefix}/lib/mkosi-initrd-dracut
%{_prefix}/lib/mkosi-initrd-dracut/dracut-lib.sh
