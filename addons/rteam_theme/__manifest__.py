{
    'name': 'RTeam Enterprise Style Icons',
    'version': '19.0.1.0.0',
    'category': 'Theme/Backend',
    'summary': 'Enterprise-style dark home menu with gradient app icons',
    'description': """
        Transforms the Odoo 19 Community home menu into an Enterprise-style
        dark grid with gradient app icons. Targets the navbar apps dropdown
        and applies card-based layout with custom SVG icons per application.
    """,
    'author': 'RTeam FZE',
    'depends': ['web'],
    'data': [],
    'assets': {
        'web.assets_backend': [
            'rteam_theme/static/src/scss/home_menu.scss',
        ],
    },
    'installable': True,
    'auto_install': False,
    'application': False,
    'license': 'LGPL-3',
}
