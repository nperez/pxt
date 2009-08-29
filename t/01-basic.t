use Test::More;
use warnings;
use strict;

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
lives_ok { SessionRefIdAliasInstantiation };

done_testing();

