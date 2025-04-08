from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '20250407_01'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    op.create_table(
        'fastinggoal',
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('user_id', sa.Integer, sa.ForeignKey('user.id'), nullable=False),
        sa.Column('label', sa.String, nullable=False),
        sa.Column('type', sa.String, nullable=False),
        sa.Column('start_date', sa.Date, nullable=False),
        sa.Column('end_date', sa.Date, nullable=False),
        sa.Column('target_count', sa.Integer, nullable=False),
        sa.Column('note', sa.Text, nullable=True),
    )

def downgrade():
    op.drop_table('fastinggoal')
