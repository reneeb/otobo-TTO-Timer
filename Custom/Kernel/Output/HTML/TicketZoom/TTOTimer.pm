# --
# Copyright (C) 2016-2018, TTO GmbH
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketZoom::TTOTimer;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Param{TicketID} = $ParamObject->GetParam( Param => 'TicketID' );

    $Param{MomentVersion} = $Self->_Version(lib => 'momentjs');
    $Param{JqueryVersion} = $Self->_Version(lib => 'jquery');

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/TTOTimer',
        Data         => { %Param },
    );

    return {
        Output => $Output,
    };
}

sub _Version {
    my ( $Self, %Param ) = @_;

    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( !$Self->{Libs} ) {
        my @Files = $MainObject->DirectoryRead(
            Directory => $ConfigObject->Get('Home') . '/var/httpd/htdocs/js/thirdparty',
            Filter    => '*',
        );

        my %Libs;

        FILE:
        for my $File ( @Files ) {
            my ($Lib, $Version) = $File =~ m{thirdparty/(.*)-([\.\d]+)$}xms;

            next FILE if !$Version;

            $Libs{$Lib} = $Version;
        }

        $Self->{Libs} = \%Libs;
    }

    return $Self->{Libs}->{ $Param{lib} };
}

1;
