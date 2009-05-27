use Test::More('tests', 9);
use warnings;
use strict;
use 5.010;

use Test::Exception;

use POEx::Types(':all');

lives_ok { Kernel };
lives_ok { Session };
lives_ok { Filter };
lives_ok { Wheel };
lives_ok { Driver };
lives_ok { WheelID };
lives_ok { SessionID };
lives_ok { SessionAlias };
lives_ok { DoesSessionInstantiation };
