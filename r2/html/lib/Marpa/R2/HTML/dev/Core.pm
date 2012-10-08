# Copyright 2012 Jeffrey Kegler
# This file is part of Marpa::R2.  Marpa::R2 is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Marpa::R2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser
# General Public License along with Marpa::R2.  If not, see
# http://www.gnu.org/licenses/.

use 5.010;
use strict;
use warnings;
use autodie;
use Data::Dumper;

package HTML_Core;

use English qw( -no_match_vars );

our $CORE_BNF = <<'END_OF_CORE_BNF';
# Non-element tokens
comment ::= C
pi ::= PI
decl ::= D
pcdata ::= PCDATA
cdata ::= CDATA
whitespace ::= WHITESPACE
cruft ::= CRUFT

FLO_SGML ::= ITEM_SGML*
ITEM_SGML ::= comment
ITEM_SGML ::= pi
ITEM_SGML ::= decl
ITEM_SGML ::= whitespace
ITEM_SGML ::= cruft

# For element x,
# ELE_x is complete element
# S_x is start tag
# E_x is end tag
#   The contents of many elements consists of zero or more items

# Top-level structure
document ::= prolog ELE_html trailer EOF
prolog ::= FLO_SGML
trailer ::= FLO_SGML
ELE_html ::= S_html Contents_html E_html
Contents_html ::= FLO_SGML ELE_head FLO_SGML ELE_body FLO_SGML
ELE_head ::= S_head FLO_head E_head
ELE_body ::= S_body FLO_block E_body

# FLO_empty, FLO_cdata and ITEM_cdata 
# do NOT allow SGML items as part of
# their flow
FLO_empty ::=

# In FLO_cdata, disallow all SGML components,
# but include cruft. ITEM_cdata is redundant,
# but is defined for orthogonality.
FLO_cdata ::= SITEM_cdata*
SITEM_cdata ::= CRUFT
SITEM_cdata ::= ITEM_cdata
ITEM_cdata ::= cdata

FLO_mixed ::= SITEM_mixed*
SITEM_mixed ::= ITEM_SGML
SITEM_mixed ::= ITEM_mixed
ITEM_mixed ::= GRP_anywhere
ITEM_mixed ::= GRP_block
ITEM_mixed ::= GRP_inline
ITEM_mixed ::= cdata
ITEM_mixed ::= pcdata

FLO_block contains GRP_block GRP_anywhere

FLO_head contains GRP_head GRP_anywhere

FLO_inline contains pcdata cdata GRP_inline GRP_anywhere

FLO_pcdata contains cdata pcdata

END_OF_CORE_BNF

1;
