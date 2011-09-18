# -*- coding: utf-8 -*-
<%inherit file="/base.mako"/>
${ c.custom_html }

<h1>The sponsoring process</h1>

<p>As sponsored maintainer you don't have upload permissions to the Debian repository. Therefore you have three possibilities to get your package into Debian:</p>

<ul>
    <li>Join a packaging team</li>
    <li>Ask the <tt>debian-mentors</tt> mailing list</li>
    <li>Talk directly to people willing to sponsor your package</li>
</ul>

<p>They will ${ h.tags.link_to("review", h.url('intro-reviewers')) } your package. Everyone is invited to review packages, including you for other people in your situation.</p>

<h2>Join a packaging team</h2>

<p>There are teams in Debian who maintain packages collaboratively. If your package deals with libraries for programming langauges, or is about an ecosystem of associated packages, think of KDE or Gnome packages for example, you may want to join that team. Have a look to <a href="http://wiki.debian.org/Teams/#Packaging_teams">list of packaging teams</a> in Debian.</p>

<p>Please note, each of those teams may have their own workflows and policies. Contact their respective mailing lists to learn more.</p>

<h2>Ask the <tt>debian-mentors</tt> mailing list</h2>

<p>If your package does not match the interests of any team, or you are not sure whether a team could be interested in your package, please write to the <tt><a href="http://lists.debian.org/debian-mentors/">debian-mentors</a></tt> mailing list to draw attention to your package. Your request should be formatted according to our RFS ("<em>request for sponsorship</em>") template. If you uploaded your package to ${ config['debexpo.sitename'] }, a RFS template can be shown on your package page.</p>

<p><em>If in doubt, choose this alternative.</em></p>

<p>Don't worry if you get no answer: It does not mean your package is bad. Ask again after a few weeks if you did not find a sponsor by other means yet. </p>

<h2>Finding a sponsor</h2>

<p>If you want, you can write sponsors willing to upload packages to other maintainers directly. <strong>Don't contact them blindly!</strong> Instead watch out for their requirements and guidelines. Contact them only if your package is compatible to their individual requirements and matches their area of interest. To tell apart sponsors who are interested in your package and who are not, they can formulate their own sponsor metrics.</p>

<h2>Sponsor metrics</h2>

To help you finding a sponsor interested in your package, they can formulate sponsor metrics:

<h3>Sponsor's personal interests</h3>

<p>Sponsors typically are not interested to upload any package for you. They could, however, be interested if your package matches their area of interest. Please compare those package types with your package. Such categories eventually are certain programming languages your program is written in, a field of endeavour, or software fulfilling a certain task. </p>

<%def name="tag_helper(requirement)">
    % if not c.sponsor_filter:
        <dt id="${requirement.tag}">${ requirement.label } (${ h.tags.link_to(  _('Filter'), h.url.current(action='toggle', tag=requirement.tag))  })</dt>
        <dd>${ requirement.long_description | n}</dd>
    % elif requirement.tag not in c.sponsor_filter:
        <dt><span id="${requirement.tag}" style="text-decoration: line-through;">${ requirement.label }</span> (${ h.tags.link_to(  _('Add to filter'), h.url.current(action='toggle', tag=requirement.tag))  })</dt>
    % else:
        <dt id="${requirement.tag}">${ requirement.label } (${ h.tags.link_to(  _('Remove filter'), h.url.current(action='toggle', tag=requirement.tag))  })</dt>
        <dd>${ requirement.long_description | n}</dd>
    % endif
</%def>

<table>
    <tr>
        <th width="50%">Acceptable package traits</th>
        <th width="50%">Social requirements</th>
    </tr>
    <tr>
        <td>
            Debian allows several workflows and best practices to co-exist with each other. All packages <strong>must comply the <a href="http://www.debian.org/doc/debian-policy/">Debian policy</a></strong> as bare essential minimum, but some workflows and best practices beyond that are optional, but nonetheless mandatory <em>for you</em> asking that person to sponsor your upload.
        </td>
        <td>
            Some sponsors prefer to upload only packages from people, that fulfill certain social criterias. Please don't ask an uploader to sponsor your request if you don't match them.
        </td>
    </tr>
    <tr>
        <td>
        <dl>
        % for requirement in c.technical_tags:
            <% tag_helper(requirement) %>
        % endfor
        </dl>
        </td>
        <td>

        <dl>
        % for requirement in c.social_tags:
            <% tag_helper(requirement) %>
        % endfor
        </dl>
        </td>
    </tr>
</table>

<hr />

<p>
% if c.sponsor_filter:
    Applied filters:
    % for filter in c.sponsor_filter:
       ${ filter }
    % endfor
- ${ h.tags.link_to(  _('Remove all filters'), h.url.current(action='clear'))  }
% endif
</p>

<table width="100%">
    <tr>
        <th width="30%">Sponsor name and contact data</th>
        <th width="35%">Acceptable package traits</th>
        <th width="35%">Social Requirements</th>
    </tr>
<%
    def preferred(flag):
        if flag:
            return "(preferred)"
        else:
            return ""

    def put_s(name):
        if name[-1] != 's':
            return 's'

    sponsors_found = False
%>
% for sponsor in c.sponsors:
    <%
        sponsor_tags = set(sponsor.get_all_tags_weighted(1))
        filters = set(c.sponsor_filter)
    %>
    % if len(filters & sponsor_tags) != len(filters):
        <% continue %>
    % endif
    <% sponsors_found = True %>
    <tr>
        <td>
            <span style="font-size:120%"><strong>${ sponsor.user.name }</strong></span>
            <br />
            <ul>
            % if sponsor.user.email and sponsor.allowed(c.constants.SPONSOR_CONTACT_METHOD_EMAIL):
                <li>Email: ${ sponsor.user.email } ${ preferred(sponsor.contact == c.constants.SPONSOR_CONTACT_METHOD_EMAIL) }</li>

            % endif
            % if sponsor.user.ircnick and sponsor.allowed(c.constants.SPONSOR_CONTACT_METHOD_IRC):
                <li>IRC: ${ sponsor.user.ircnick } ${ preferred(sponsor.contact == c.constants.SPONSOR_CONTACT_METHOD_IRC) }</li>
            % endif
            % if sponsor.user.jabber and sponsor.allowed(c.constants.SPONSOR_CONTACT_METHOD_JABBER):
                <li>Jabber: ${ sponsor.user.jabber } ${ preferred(sponsor.contact == c.constants.SPONSOR_CONTACT_METHOD_JABBER) }</li>
            % endif
            </ul>
            <strong>Personal interests</strong>
            <p>${ sponsor.get_types() | n,semitrusted}</p>
        </td>
        <td>
            <ul>
            % for tag in sponsor.get_technical_tags_full():
                % if tag.weight > 0:
                    <li> <span style="color: green;">+ ${ tag.full_tag.label }</span> (<a href="${ h.url.current(anchor=tag.tag)  }">?</a>)</li>
                % elif tag.weight < 0:
                    <li> <span style="color: red;">- ${ tag.full_tag.label }</span> (<a href="${ h.url.current(anchor=tag.tag)  }">?</a>)</li>
                % endif
            % endfor
            </ul>
            <p>
            % if sponsor.guidelines == c.constants.SPONSOR_GUIDELINES_TYPE_URL:
                <a href="${ sponsor.get_guidelines()}">${ sponsor.user.name  }'${ put_s(sponsor.user.name) } personal guidelines</a>
            % else:
                ${ sponsor.get_guidelines() | semitrusted}
            % endif
            </p>
        </td>
        <td>
            <ul>
            % for tag in sponsor.get_social_tags_full():
                % if tag.weight > 0:
                    <li> <span style="color: green;">+ ${ tag.full_tag.label }</span> (<a href="${ h.url.current(anchor=tag.tag)  }">?</a>)</li>
                % elif tag.weight < 0:
                    <li> <span style="color: red;">- ${ tag.full_tag.label }</span> (<a href="${ h.url.current(anchor=tag.tag)  }">?</a>)</li>
                % endif
            % endfor
            </ul>
            ${ sponsor.get_social_requirements() | n,semitrusted}
        </td>
    </tr>
% endfor
%if not sponsors_found and c.sponsor_filter:
    <tr>
        <td colspan="3" style="text-align:center"><br /><strong>${ _('No sponsor matched your criteria') }</strong></td>
    </tr>
%elif not sponsors_found:
    <tr>
        <td colspan="3" style="text-align:center"><br /><strong>${ _('No sponsors found') }</strong></td>
    </tr>
%endif
</table>

% if c.sponsor_filter:
    <p>${ h.tags.link_to(  _('Remove all filters'), h.url.current(action='clear'))  }</p>
% endif
