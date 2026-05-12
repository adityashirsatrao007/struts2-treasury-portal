import matplotlib.pyplot as plt
import matplotlib.patches as patches

def create_workflow_plot():
    fig, ax = plt.subplots(figsize=(12, 8))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 10)
    ax.axis('off')

    # Define nodes
    nodes = [
        (5, 9, "Start: index.php", "ellipse"),
        (5, 7.5, "User Input: Note Text", "box"),
        (5, 6, "Action: Click Add Note", "box"),
        (5, 4.5, "Server: PHP POST Request", "diamond"),
        (5, 3, "Database: MySQL INSERT", "box"),
        (5, 1.5, "Display: Dynamic UI Update", "box"),
        (5, 0.5, "End", "ellipse")
    ]

    # Draw nodes
    for x, y, text, shape in nodes:
        if shape == "ellipse":
            patch = patches.FancyBboxPatch((x-1.5, y-0.3), 3, 0.6, boxstyle="round,pad=0.1", fc='#E3F2FD', ec='#1976D2')
        elif shape == "diamond":
            patch = patches.RegularPolygon((x, y), 4, radius=0.8, orientation=0, fc='#FFF3E0', ec='#FB8C00')
        else:
            patch = patches.FancyBboxPatch((x-1.5, y-0.3), 3, 0.6, boxstyle="square,pad=0.1", fc='#F5F5F5', ec='#757575')
        
        ax.add_patch(patch)
        ax.text(x, y, text, ha='center', va='center', fontsize=10, fontweight='bold')

    # Draw arrows
    for i in range(len(nodes)-1):
        ax.annotate('', xy=(nodes[i+1][0], nodes[i+1][1]+0.3), xytext=(nodes[i][0], nodes[i][1]-0.3),
                    arrowprops=dict(arrowstyle='->', lw=1.5, color='#424242'))

    plt.title("Notes App: System Workflow Execution", fontsize=16, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig('workflow_plot.png', dpi=300, bbox_inches='tight')
    print("Workflow plot saved as workflow_plot.png")

if __name__ == "__main__":
    create_workflow_plot()
